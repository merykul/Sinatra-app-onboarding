module ControllerHelper
  def update_user(user, if_error_erb, parameters, if_success_erb)
    password_status = user.password_status
    p "Password status: #{password_status}"

    user.update(parameters)

    if user.valid?
      user.save
      p 'User is updated successfully!'
      p "Password status: #{user.password_status}"
      p "Username: #{user.username}"
      redirect to if_success_erb
    else
      @error_messages = @user.errors.full_messages
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
