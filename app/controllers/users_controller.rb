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
      password_status = 'temporary'

      user = User.create(
        first_name: first_name,
        second_name: second_name,
        username: username,
        password: password,
        password_confirmation: password_confirmation,
        password_status: password_status
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

  get '/set_password' do
    @user = User.find(session[:user_id])
    @password_status = @user.password_status
    p "User id: #{@user.id}"
    p "Password status: #{@password_status}"
    erb :'user/set_password'
  end

  patch '/set_password' do
    username = params[:new_username]
    new_password = params[:new_password]
    password_confirmation = params[:confirm_password]
    @user = User.find(session[:user_id])

    p "New username: #{username}"

    @user.update(password: new_password, password_confirmation: password_confirmation, username: username, password_status: 'permanent')

    if @user.temporary_password?
      p 'Error while updating user'
      erb :'user/set_password'
    else
      @user.save
      p 'New password and username is set successfully!'
      p "Password status: #{@user.password_status}"
      p "New username: #{@user.username}"
      redirect to '/homepage'
    end
  end

  get '/user/:id/edit' do
    @user = User.find(params[:id])
    p "Retrieved user id: #{params[:id]}"

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

      @user.update_columns(
        first_name: first_name,
        second_name: second_name,
        username: username
      )

      p 'User is updated, but not validated yet'

      if @user.valid?
        @user.save
        p 'User is updated successfully!'
        redirect to '/manage_users'
      else
        @error_messages = @user.errors.full_messages
        p 'ERROR'
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

  get '/user/:id/delete/with_records' do
    if logged_in?
      @user = User.find(params[:id])
      @records = Records.where(:user_id => params[:id])
      username = @user.username

      @user.delete_with_records(@user, @records)

      p "#{username} user is deleted with records!"
      redirect to '/manage_users'
    else
      redirect to '/start'
    end
  end
end
