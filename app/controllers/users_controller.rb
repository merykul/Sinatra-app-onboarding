require_relative './application_controller'

class UsersController < ApplicationController

  get '/manage_users' do
    redirect_if_not_logged_in
    if_user_display_access_error
    @users = User.where(:role => 'user')
    erb :'user/manage'
  end

  get '/create_user' do
    if_user_display_access_error
    erb :'user/create'
  end

  post '/create_user_form' do
    redirect_if_not_logged_in
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
  end

  get '/set_password' do
    @user = User.find(session[:user_id])
    erb :'user/set_password'
  end

  patch '/set_password' do
    p "New username: #{params[:new_username]}"
    @user = User.find(session[:user_id])

    update_user(@user, :'user/set_password', { password: params[:new_password],
                                               password_confirmation: params[:confirm_password],
                                               username: params[:new_username],
                                               password_status: 'permanent' }, '/homepage')
  end

  get '/user/:id/edit' do
    @user = find_user(:id, params[:id])

    if_user_display_access_error
    erb :'user/edit'
  end

  patch '/user/:id/edit' do
    redirect_if_not_logged_in
    @user = find_user(:id, params[:id])

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
  end

  get '/user/:id/delete' do
    @user = find_user(:id, params[:id])
    @user_records = Records.where(:user_id => params[:id])

    if_user_display_access_error
    erb :'user/delete'
  end

  get '/user/:id/delete/with_records' do
    redirect_if_not_logged_in
    @user = find_user(:id, params[:id])
    @records = Records.where(:user_id => params[:id])
    username = @user.username

    @user.delete_with_records(@user, @records)

    p "#{username} user is deleted with records!"
    redirect to '/manage_users'
  end

  get '/user/:id/delete/with_records_transfer' do
    redirect_if_not_logged_in
    @user = find_user(:id, params[:id])
    @records = Records.where(:user_id => params[:id])
    @users = User.where(:role => 'user').where.not(:id => params[:id])

    erb :'user/delete_with_records_transfer'
  end

  post '/user/:id/delete/with_records_transfer' do
    @user = find_user(:id, params[:id])
    @records = Records.where(:user_id => params[:id])
    username = @user.username
    selected_user_id = params[:selected_user_id]
    p "Selected user ID: #{selected_user_id}"

    @user.delete_with_records_transfer(@user, @records, selected_user_id)

    p "#{username} is deleted and records are transferred to user with id: #{selected_user_id}!"
    redirect to '/manage_users'
  end

  get '/user/:id/delete/with_records_transfer_to_new_user' do
    if logged_in?
      # to do
      redirect to '/manage_users'
    else
      redirect to '/start'
    end
  end
end
