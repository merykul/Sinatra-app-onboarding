module AuthHelper
  def log_in(username, password)
    post '/log_in', username: username, password: password
  end
end
