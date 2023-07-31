require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require 'dotenv/load'
require_relative 'models/records'
require_relative 'models/city'
require_relative 'models/user'

# global settings
configure do
  set :root, File.dirname(__FILE__ )
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :database_file, 'config/database.yml'
  set :sessions, true
  set :session_secret, ENV['SESSION_SECRET']

  register Sinatra::ActiveRecordExtension
end

get '/' do
  if logged_in?
    @user = current_user
    erb :homepage
  else
    redirect to '/log_in_form'
  end
end

# don't need this page, but let it be here for now
get '/start' do
  erb(:"user/start_page")
end

# user's login page
get '/log_in_form' do
  if logged_in?
    redirect to '/homepage'
  else
    erb(:"user/login_page")
  end
end

post '/log_in' do
  username = params[:username]
  password = params[:password]

  user = User.find_by(:username == username)
  if user && user.authenticate(password)
    session[:user_id] = user.id
    puts "Successful logged in!"
    redirect to '/homepage'
  else
    @error_messages = ["Invalid username or password"]
    erb(:"user/login_page")
  end
end

get '/log_out' do
  session.clear
  redirect to '/start'
end

# sign up user:
get '/sign_up_form' do
  if logged_in?
    redirect to '/homepage'
  else
    erb(:"user/sign_up_page")
  end
end

post '/sign_up' do
    username = params[:username]
    password = params[:password]
    first_name = params[:first_name]
    second_name = params[:second_name]

    @user = User.new(
      username: username,
      password: password,
      first_name: first_name,
      second_name: second_name,
      password_confirmation: params[:password_confirmation]
    )
    session[:user_id] = @user.id

    if @user.valid?
      @user.save
      redirect '/homepage'
    else
      @error_messages = @user.errors.full_messages
      erb(:"user/sign_up_page")
    end
end

get '/homepage' do
  if logged_in?
    erb :homepage
  else
    erb(:"user/login_page")
  end
end

# index
get '/people_list' do
  if logged_in?
    @records = Records.all
    erb(:"records/index")
  else
    redirect to '/start'
  end
end

# statistics
get '/cities_statistics' do
  if logged_in?
    @statistics = City.all
    erb(:"cities/statistics")
  else
    redirect to '/start'
  end
end

# to create record:
get '/added_person_form' do
  if logged_in?
    erb :create_person_form
  else
    redirect to '/start'
  end
end

# create_person_form
post '/create_person' do
  first_name = params[:first_name]
  second_name = params[:second_name]
  city = params[:city]
  date_of_birth = params[:date_of_birth]

  record = Records.new(
    first_name: first_name,
    second_name: second_name,
    city: city,
    date_of_birth: date_of_birth
  )

  if record.valid?
    record.save
    "Person is added to the records! Full name: #{first_name} #{second_name}, City: #{city}"
    redirect('/people_list')
  else
    @error_messages = record.errors.full_messages
    erb :create_person_form
  end
end

# edit

get '/records/:id/edit' do
  if logged_in?
    @record = Records.find(params[:id])
    erb(:"records/edit")
  else
    redirect to '/start'
  end
end

put '/records/:id/edit' do
  @record = Records.find(params[:id])
  @record.update(
    first_name: params[:first_name],
    second_name: params[:second_name],
    city: params[:city],
    date_of_birth: params[:date_of_birth]
  )

  if @record.valid?
    @record.save
    redirect "/people_list"
  else
    @error_messages = @record.errors.full_messages
    erb(:"records/edit")
  end
end

get '/records/:id/delete' do
  if logged_in?
    @record = Records.find(params[:id])
    erb(:"records/delete")
  else
    redirect to '/start'
  end
end

delete '/records/:id/delete' do
  @record = Records.find(params[:id])
  @record.delete

  redirect "/people_list"
end

# Error handling pages
error 404, 400, 401, 403 do
  erb :error_400ish
end

error 500, 501, 502, 503, 504, 505 do
  'Ops, server error'
end

# Helpers

helpers do

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find_by(:id == session[:user_id])
  end

  def redirect_if_not_logged_in
    if !logged_in?
      redirect to '/login'
    end
  end
end
