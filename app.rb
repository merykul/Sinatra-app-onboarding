require 'sinatra'
# this allows us to refresh the app on the browser without needing to restart the web server
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'

# global settings
configure do
  set :root, File.dirname(__FILE__ )
  set :public_folder, File.dirname(__FILE__) + '/public'

  register Sinatra::ActiveRecordExtension
end

set :database_file, 'config/database.yml'

get '/homepage' do
  erb :homepage
end

# RESTful Records Controllers Actions
# index
get '/people_list' do
  @records = People.all
  erb(:"records/index")
end

# create_person_form
post '/create_person' do
  first_name = params[:first_name]
  second_name = params[:second_name]
  city = params[:city]
  date_of_birth = params[:date_of_birth]

  if first_name.empty? || second_name.empty? || city.empty?
    return "Fill in all required fields (first and second name, city)"
  end

  birth_date_message = date_of_birth.empty? ? "Date of birth is unknown" : "Date of birth: #{date_of_birth}"

  "Person is added to the records! Full name: #{first_name} #{second_name}, City: #{city}, #{birth_date_message}"
end

get '/added_person_form' do
  erb :create_person_form
end

put '/edit_persons_data' do
  'Edit person page'
end

delete '/delete_person_record' do
  'Delete record page'
end

# Error handling pages
error 404, 400, 401, 403 do
  'Ops, entered endpoint is not valid :)'
  redirect('/homepage')
end

error 500, 501, 502, 503, 504, 505 do
  'Ops, server error'
end
