# frozen_string_literal: true

require_relative './application_controller'

class RecordsController < ApplicationController

  # index
  get '/people_list' do
    error_if_not_logged_in
    city_filter = params[:city]
    user_id = current_user.id
    @records = current_user.role == 'admin' ? Records.all : Records.where(:user_id => user_id)
    @output = city_filter && !city_filter.strip.empty? ? @records.where(:city => "#{city_filter}") : @records

    if city_filter && @output.empty?
      @error_message = 'There is no records with this city'
      response.status = 400
    end

    erb :'../views/records/people_list'
  end

  # statistics
  get '/cities_statistics' do
    error_if_not_logged_in
    @statistics = City.all
    erb(:"cities/statistics")
  end

  # to create record:
  get '/added_person_form' do
    error_if_not_logged_in
    erb :create_person_form
  end

  # create_person_form
  post '/create_person' do
    error_if_not_logged_in
    opts = { first_name: params[:first_name],
             second_name: params[:second_name],
             city: params[:city],
             date_of_birth: params[:date_of_birth],
             user_id: current_user.id }

    create_record('/people_list', opts, :create_person_form)
  end

  # edit
  get '/records/:id/edit' do
    error_if_not_logged_in
    @record = find_record(:id, params[:id])
    if_prohibited_display_error(@record)
    erb :'/records/edit'
  end

  patch '/records/:id/edit' do
    error_if_not_logged_in
    @record = find_record(:id, params[:id])
    if_prohibited_display_error(@record)

    opts = { first_name: params[:first_name],
             second_name: params[:second_name],
             city: params[:city],
             date_of_birth: params[:date_of_birth] }

    update_record(@record, '/people_list', opts, :'records/edit')
  end

  # delete
  get '/records/:id/delete' do
    error_if_not_logged_in
    @record = find_record(:id, params[:id])
    if_prohibited_display_error(@record)
    if @record.nil?
      response.status = 404
      erb :'errors/error_404'
    else
      response.status = 200
      erb :'records/delete'
    end
  end

  delete '/records/:id/delete' do
    error_if_not_logged_in
    @record = find_record(:id, params[:id])
    if_prohibited_display_error(@record)
    if @record.nil?
      response.status = 404
      erb :'errors/error_404'
    else
      @record.delete
      response.status = 200
      headers['Location'] = '/people_list'
      erb :'success_templates/deleted_record'
    end
  end
end
