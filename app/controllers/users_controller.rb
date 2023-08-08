require_relative './application_controller'

class UsersController < ApplicationController

  get '/manage_users' do
    if current_user.role == 'admin'
      @users = User.where(:role => 'user')
      erb :'user/manage'
    else
      erb :'errors/users_profiles_access_error'
    end
  end

  get '/create_user' do
    if current_user.role == 'admin'
      erb :'user/create'
    else
      erb :'errors/users_profiles_access_error'
    end
  end

  post '/create_user_form' do
    if logged_in?
      first_name = params[:first_name]
      second_name = params[:second_name]
      username = params[:username]
      password = params[:password]
      password_confirmation = params[:password_confirmation]

      user = User.create(
        first_name: first_name,
        second_name: second_name,
        username: username,
        password: password,
        password_confirmation: password_confirmation
      )

      if user.valid?
        user.save
        p "User is create successfully! Full name: #{first_name} #{second_name}, username: #{username}, temporary password: #{password}"
        redirect to '/manage_users'
      else
        @error_messages = user.errors.full_messages
        erb :'user/create'
      end
    else
      redirect to '/start'
    end
  end

  get '/user/:id/edit' do
    if current_user.role == 'admin'
      erb :'user/edit'
    else
      erb :'errors/users_profiles_access_error'
    end
  end

  patch '/user/:id/edit' do
    if logged_in?
      @user = User.find_by(:id => params[:id])

      first_name = params[:first_name]
      second_name = params[:second_name]
      username = params[:username]
      #TODO: Manage editing without password validation
      password = nil

      @user.update(
        first_name: first_name,
        second_name: second_name,
        username: username,
        password: password,
        password_confirmation: password
      )

      p 'User is updated, but not validated yet'

      if @user.valid?
        @user.save
        p 'User is updated successfully!'
      else
        @error_messages = @user.errors.full_messages
        erb :'user/edit'
      end
    else
      redirect to '/start'
    end
  end

  get '/user/:id/delete' do
    @user = User.find(params[:id])
    @user_records = Records.where(:user_id => params[:id])
    p "Retrieved user id: #{params[:id]}"

    if current_user.role == 'admin'
      erb :'user/delete'
    else
      erb :'errors/users_profiles_access_error'
    end
  end

  delete '/user/:id/delete' do
    if logged_in?
      @user = User.find(params[:id])

      p 'User is deleted!'
      redirect to '/manage_users'
    else
      redirect to '/start'
    end
  end
end
