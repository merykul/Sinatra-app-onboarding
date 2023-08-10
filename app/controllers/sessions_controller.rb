require_relative 'application_controller'

class SessionsController < ApplicationController

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
    if user && user.authenticate(password)
      session[:user_id] = user.id
      if user.temporary_password?
        redirect to '/set_password'
      else
        puts 'Successful logged in!'
        puts "User role: #{current_user.role}"
        puts "User id: #{current_user.id}"
        redirect to '/homepage'
      end
    else
      @error_messages = ["Invalid #{username} username or #{password} password!"]
      erb :'user/login_page'
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
      erb :'user/sign_up_page'
    end
  end

  post '/sign_up' do
    username = params[:username]
    password = params[:password]
    first_name = params[:first_name]
    second_name = params[:second_name]
    password_confirmation = params[:password_confirmation]
    password_status = 'permanent'

    @error_messages = ["Password confirmation doesn't match password"] unless password_confirmation == password
    @user = User.new(
      username: username,
      password: password,
      first_name: first_name,
      second_name: second_name,
      password_confirmation: password_confirmation,
      password_status: password_status
    )

    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect '/homepage'
    else
      @error_messages = @user.errors.full_messages
      erb :'user/sign_up_page'
    end
  end

  get '/homepage' do
    redirect_if_not_logged_in
  end
end
