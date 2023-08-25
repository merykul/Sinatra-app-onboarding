# frozen_string_literal: true

module RecordsHelper
  def update_record(record, if_success_route, parameters, if_error_erb)
    record.update(parameters)

    if record.valid?
      record.save
      p 'Record is updated successfully!!'

      response.status = 200
      headers['Location'] = if_success_route
      erb :'success_templates/updated_record'
    else
      response.status = 400
      @error_messages = record.errors.full_messages
      erb if_error_erb
    end
  end

  def create_record(if_success_route, parameters, if_error_erb)
    record = Records.create(parameters)

    if record.valid?
      record.save
      p 'Person is added to the records!'
      p "Current user id: #{current_user.id}"

      response.status = 201
      headers['Location'] = if_success_route
      erb :'success_templates/created_record'
    else
      response.status = 400
      @error_messages = record.errors.full_messages
      erb if_error_erb
    end
  end

  private

  def find_record(param, value)
    Records.find_by(param => value)
  end

  # maybe will be removed soon
  def check_access_to_records(record, success_route)
    if record && (record.user_id == current_user.id || current_user.role == 'admin')
      erb success_route
    else
      response.status = 403
      @error_messages = ['Record is not accessible for current user']
      erb :'errors/record_access_error'
    end
  end

  def if_prohibited_display_error(record)
    unless record.nil? || (record.user_id == current_user.id || current_user.role == 'admin')
      halt 403, MultiJson.dump({ message: "You aren't allowed to access this record" })
    end
  end
end
