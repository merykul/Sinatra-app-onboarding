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
      redirect to if_success_route
    else
      @error_messages = @user.errors.full_messages
      erb if_error_erb
    end
  end

  def create_user(if_success_route, parameters, if_error_erb)
    user = User.create(parameters)

    if user.valid?
      user.save
      session[:user_id] = user.id
      p 'User is create successfully!'
      redirect to if_success_route
    else
      @error_messages = user.errors.full_messages
      erb if_error_erb
    end
  end

  private

  def if_user_display_access_error
    redirect to '/users_management_access_error' unless current_user.role == 'admin'
  end

  def find_user(param, value)
    User.find_by(param => value)
  end
end
