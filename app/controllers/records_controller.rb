# frozen_string_literal: true

require_relative './application_controller'

class RecordsController < ApplicationController

  # index
  get '/people_list' do
    redirect_if_not_logged_in
    city_filter = params[:city]
    user_id = current_user.id
    @records = current_user.role == 'admin' ? Records.all : Records.where(:user_id => user_id)

    @output = if city_filter && !city_filter.strip.empty?
                @records.where(:city => "#{city_filter}")
              else
                @records
              end
    erb :'../views/records/people_list'
  end

  # statistics
  get '/cities_statistics' do
    redirect_if_not_logged_in
    @statistics = City.all
    erb(:"cities/statistics")
  end

  # to create record:
  get '/added_person_form' do
    redirect_if_not_logged_in
    erb :create_person_form
  end

  # create_person_form
  post '/create_person' do
    redirect_if_not_logged_in
    create_record('/people_list', { first_name: params[:first_name],
                                    second_name: params[:second_name],
                                    city: params[:city],
                                    date_of_birth: params[:date_of_birth],
                                    user_id: current_user.id }, :create_person_form)
  end

  # edit
  get '/records/:id/edit' do
    @record = Records.find(params[:id])
    p "Record is retrieved: id = #{params[:id]}"
    p "User id for requested record: #{current_user.id}"

    check_access_to_records(@record, :'records/edit')
  end

  patch '/records/:id/edit' do
    redirect_if_not_logged_in
    @record = Records.find(params[:id])

    update_record(@record, '/people_list', { first_name: params[:first_name],
                                             second_name: params[:second_name],
                                             city: params[:city],
                                             date_of_birth: params[:date_of_birth] }, :'records/edit')
  end

  # delete
  get '/records/:id/delete' do
    @record = Records.find(params[:id])
    p "Record is retrieved: id = #{params[:id]}"
    p "User id for requested record: #{current_user.id}"

    check_access_to_records(@record, :'records/delete')
  end

  delete '/records/:id/delete' do
    redirect_if_not_logged_in
    @record = Records.find(params[:id])
    @record.delete
    redirect to '/people_list'
  end
end
