# frozen_string_literal: true

module RecordsHelper
  def update_record(record, if_success_route, parameters, if_error_erb)
    record.update(parameters)

    if record.valid?
      record.save
      p 'Record is updated successfully!!'

      redirect to if_success_route
    else
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
      redirect to if_success_route
    else
      @error_messages = record.errors.full_messages
      erb if_error_erb
    end
  end

  private

  def check_access_to_records(record, success_route)
    if record.user_id == current_user.id || current_user.role == 'admin'
      erb success_route
    else
      @error_messages = ['Record is not accessible for current user']
      erb :'errors/record_access_error'
    end
  end
end
