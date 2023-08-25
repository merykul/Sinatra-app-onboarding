require_relative '../helpers/logs_helper'

module AuthHelper
  def log_in(username, password)
    post '/log_in', username: username, password: password
  end

  def log_out
    get '/log_out'
  end
end
