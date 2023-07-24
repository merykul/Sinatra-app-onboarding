require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/homepage' do
  "Hello world!"
end

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

get '/people_list' do
  'Page should display records list'
end

error 404 do
  'Ops, entered endpoint is not valid :)'
end
