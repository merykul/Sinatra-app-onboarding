# frozen_string_literal: true

require_relative 'application_controller'

class SessionsController < ApplicationController
  include UserHelper

  get '/start' do
    erb :'user/start_page'
  end

  # user's login page
  get '/log_in_form' do
    if logged_in?
      redirect to '/homepage'
    else
      erb :'/user/login_page'
    end
  end

  post '/log_in' do
    username = params[:username]
    password = params[:password]

    user = find_user(:username, username)
    if user&.authenticate(password)
      session[:user_id] = user.id
      if user.temporary_password?
        redirect to "/user/#{user.id}/set_password"
      else
        puts 'Successful logged in!'
        puts "User role: #{current_user.role}"
        puts "User id: #{current_user.id}"
        redirect to '/homepage'
      end
    else
      @error_messages = ["Invalid #{username} username or #{password} password!"]
      response.status = 400
      erb :'user/login_page'
    end
  end

  get '/log_out' do
    session.clear
    response.status = 200
    erb :'user/start_page'
  end

  # sign up user:
  get '/sign_up_form' do
    if logged_in?
      redirect to '/homepage'
    else
      erb :'user/sign_up_page'
    end
  end

  post '/sign_up' do
    p "User parameters: #{params[:username]}, #{params[:first_name]}, #{params[:second_name]}"
    admin_creates = false
    password_confirmation = params[:password_confirmation]
    password = params[:password]
    opts = { username: params[:username],
             password: params[:password],
             first_name: params[:first_name],
             second_name: params[:second_name],
             password_confirmation: params[:password_confirmation],
             password_status: 'permanent' }

    @error_messages = ["Password confirmation doesn't match password"] unless password_confirmation == password

    create_user(admin_creates, opts, '/homepage', :'user/sign_up_page')
  end

  get '/homepage' do
    error_if_not_logged_in
    erb :homepage
  end
end
