require_relative './application_controller'

class RecordsController < ApplicationController

  # index
  get '/people_list' do
    if logged_in?
      city_filter = params[:city]

      if city_filter && !city_filter.strip.empty?
        @records = Records.where('city' => "#{city_filter}")
        erb :"../views/records/people_list"
      else
        @records = Records.all
        erb :"../views/records/people_list"
      end
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
    user_id = current_user.id

    record = Records.new(
      first_name: first_name,
      second_name: second_name,
      city: city,
      date_of_birth: date_of_birth,
      user_id: user_id
    )

    if record.valid?
      record.save
      p "Person is added to the records! Full name: #{first_name} #{second_name}, City: #{city}"
      p "Current user id: #{current_user.id}"
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
      erb :"records/edit"
    else
      redirect to '/start'
    end
  end

  patch '/records/:id/edit' do
    @record = Records.find(params[:id])
    puts "Record id is retrieved: #{params[:id]}"

    @record.update(
      first_name: params[:first_name],
      second_name: params[:second_name],
      city: params[:city],
      date_of_birth: params[:date_of_birth]
    )
    puts 'Record is updated, but not validated yet'

    if @record.valid?
      @record.save
      redirect '/people_list'
    else
      @error_messages = @record.errors.full_messages
      erb :"records/edit"
    end
  end

  get '/records/:id/delete' do
    if logged_in?
      @record = Records.find(params[:id])
      erb :"records/delete"
    else
      redirect to '/start'
    end
  end

  delete '/records/:id/delete' do
    @record = Records.find(params[:id])
    @record.delete

    redirect '/people_list'
  end
end
