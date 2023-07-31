class RecordsController < ApplicationController

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
end