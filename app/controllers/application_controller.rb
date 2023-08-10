require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require 'dotenv/load'
require 'axlsx'
require_relative '../models/city'
require_relative '../models/user'
require_relative '../models/records'

class ApplicationController < Sinatra::Base

  # global settings
  configure do
    set :root, File.dirname(File.dirname(File.dirname(__FILE__)))
    set :public_folder, File.dirname(File.dirname(File.dirname(__FILE__))) + '/public'
    set :database_file, './config/database.yml'
    set :sessions, true
    set :session_secret, ENV['SESSION_SECRET']
    set :views, Proc.new { File.join(root, '/app/views') }
    set method_override: true

    register Sinatra::ActiveRecordExtension
    use Rack::MethodOverride
  end

  # Error handling pages
  error 404 do
    erb :'errors/error_404'
  end

  error 401 do
    erb :'errors/error_401'
  end

  error 403 do
    erb :'errors/error_403'
  end

  error 500, 501, 502, 503, 504, 505 do
    erb :'errors/error_500'
  end

  # Helpers

  private

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by(id: session[:user_id])
    end

    def redirect_if_not_logged_in
      redirect to '/start' unless logged_in?
    end
  end
end
