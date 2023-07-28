require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require_relative 'models/records'
require_relative 'models/city'
require_relative 'models/user'

# global settings
configure do
  set :root, File.dirname(__FILE__ )
  set :public_folder, File.dirname(__FILE__) + '/public'
  register Sinatra::ActiveRecordExtension
end

set :database_file, 'config/database.yml'

get '/start' do
  erb(:"user/start_page")
end

# user's login page
get '/log_in_form' do
  erb(:"user/login_page")
end

# RESTful Records Controllers Actions
# index
get '/people_list' do
  @records = Records.all
  erb(:"records/index")
end

# statistics
get '/cities_statistics' do
  @statistics = City.all
  erb(:"cities/statistics")
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

get '/added_person_form' do
  erb :create_person_form
end

# edit
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

get '/records/:id/edit' do
  @record = Records.find(params[:id])
  erb(:"records/edit")
end

get '/records/:id/delete' do
  @record = Records.find(params[:id])
  erb(:"records/delete")
end

delete '/records/:id/delete' do
  @record = Records.find(params[:id])
  @record.delete

  redirect "/people_list"
end

# Error handling pages
error 404, 400, 401, 403 do
  'Ops, entered endpoint is not valid :)'
end

error 500, 501, 502, 503, 504, 505 do
  'Ops, server error'
end
