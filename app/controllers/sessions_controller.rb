require_relative 'application_controller'

class SessionsController < ApplicationController

  get '/start' do
    erb :'user/start_page'
  end

  # user's login page
  get '/log_in_form' do
    if logged_in?
      erb :homepage
    else
      erb(:"/user/login_page")
    end
  end

  post '/log_in' do
    username = params[:username]
    password = params[:password]

    user = User.find_by(:username => username)
    if user && user.authenticate(password)
      session[:user_id] = user.id
      puts "Successful logged in!"
      redirect to '/homepage'
    else
      @error_messages = ["Invalid #{username} username or #{password} password!"]
      erb(:"user/login_page")
    end
  end

  get '/log_out' do
    session.clear
    erb(:"/user/start_page")
  end

  # sign up user:
  get '/sign_up_form' do
    if logged_in?
      erb :homepage
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

    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect to '/homepage'
    else
      @error_messages = @user.errors.full_messages
      erb(:"user/sign_up_page")
    end
  end

  get '/homepage' do
    if logged_in?
      erb :homepage
    else
      erb :'user/start_page'
    end
  end
end
