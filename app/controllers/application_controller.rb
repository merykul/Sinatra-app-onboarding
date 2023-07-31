require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require 'dotenv/load'
require_relative '../../models/city'
require_relative '../../models/user'
require_relative '../../models/records'

class ApplicationController < Sinatra::Base

  # global settings
  configure do
    set :root, File.dirname(__FILE__ )
    set :public_folder, File.dirname(__FILE__) + '/public'
    set :database_file, 'config/database.yml'
    set :sessions, true
    set :session_secret, ENV['SESSION_SECRET']

    register Sinatra::ActiveRecordExtension
  end

  #main route
  get '/' do
    if logged_in?
      @user = current_user
      erb :homepage
    else
      redirect to '/log_in_form'
    end
  end

  # Error handling pages
  error 404, 400, 401, 403 do
    erb :error_400ish
  end

  error 500, 501, 502, 503, 504, 505 do
    'Ops, server error'
  end

  # Helpers

  private

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by(:id => session[:user_id])
    end

    def redirect_if_not_logged_in
      if !logged_in?
        redirect to '/login'
      end
    end
  end
end
