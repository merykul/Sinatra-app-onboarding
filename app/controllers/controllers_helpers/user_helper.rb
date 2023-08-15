# frozen_string_literal: true

module UserHelper
  def update_user(user, if_error_erb, parameters, if_success_route)
    p "Password status: #{user.password_status}"
    user.update(parameters)

    if user.valid?
      user.save
      p 'User is updated successfully!'
      p "Password status: #{user.password_status}"
      p "Username: #{user.username}"

      response.status = 200
      headers['Location'] = if_success_route
      erb :'success_templates/updated_user'
    else
      @error_messages = @user.errors.full_messages
      erb if_error_erb
    end
  end

  def create_user(admin_creates, parameters,  if_success_route = nil, if_error_erb = nil)
    user = User.create(parameters)

    if user.valid?
      user.save
      p 'Passed user validation'
      session[:user_id] = user.id unless admin_creates
      p 'User is create successfully!'

      response.status = 201
      headers['Location'] = if_success_route
      erb :'success_templates/template'
    else
      p 'Error while user validation'
      @error_messages = user.errors.full_messages
      response.status = 400
      erb if_error_erb
    end
  end

  private

  def if_user_display_access_error
    halt 403, MultiJson.dump({message: "You are not allowed to access this resource"}) unless current_user.role == 'admin'
  end

  def find_user(param, value)
    User.find_by(param => value)
  end
end
