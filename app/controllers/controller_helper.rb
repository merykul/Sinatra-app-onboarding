module ControllerHelper
  def update_user(user, parameters)
    user.update(parameters)
  end

  private

  def if_user_display_access_error
    redirect to '/users_management_access_error' unless current_user.role == 'admin'
  end

  def find_user(param, value)
    User.find_by(param => value)
  end
end
