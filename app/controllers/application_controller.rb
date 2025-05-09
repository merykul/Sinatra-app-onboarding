# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require 'dotenv/load'
require 'axlsx'
require_relative '../controllers/controllers_helpers/user_helper'
require_relative '../controllers/controllers_helpers/records_helper'
require_relative '../models/city'
require_relative '../models/user'
require_relative '../models/records'

class ApplicationController < Sinatra::Base
  include UserHelper
  include RecordsHelper

  # global settings
  configure do
    set :root, File.dirname(File.dirname(File.dirname(__FILE__)))
    set :public_folder, "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/public"
    set :database_file, './config/database.yml'
    set :sessions, true
    set :views, Proc.new { File.join(root, '/app/views') }
    set method_override: true

    register Sinatra::ActiveRecordExtension
    use Rack::MethodOverride
    set :session_secret, ENV['SESSION_SECRET']
  end

  # Access errors routes

  get '/users_management_access_error' do
    erb :'errors/users_profiles_access_error'
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

    def error_if_not_logged_in
      halt 401, MultiJson.dump({ message: 'You are not authorized to access this resource' }) unless logged_in?
    end
  end
end
