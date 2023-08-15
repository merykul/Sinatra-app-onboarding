require_relative './application_controller'

class UsersController < ApplicationController

  get '/manage_users' do
    error_if_not_logged_in
    if_user_display_access_error
    @users = User.where(:role => 'user')
    erb :'user/manage'
  end

  get '/create_user' do
    if_user_display_access_error
    erb :'user/create'
  end

  post '/create_user_form' do
    admin_creates = true
    error_if_not_logged_in
    opts = { first_name: params[:first_name],
             second_name: params[:second_name],
             username: params[:username],
             password: params[:password],
             password_confirmation: params[:password_confirmation],
             password_status: 'temporary' }

    create_user(admin_creates, opts, '/manage_users', :'user/create')
  end

  get '/user/:id/set_password' do
    @user = User.find(session[:user_id])
    p "User id check: #{@user.id}"
    erb :'user/set_password'
  end

  patch '/user/:id/set_password' do
    p "New username: #{params[:new_username]}"
    @user = User.find(session[:user_id])
    opts = { password: params[:new_password],
             password_confirmation: params[:confirm_password],
             username: params[:new_username],
             password_status: 'permanent' }

    update_user(@user, :'user/set_password', opts, '/homepage')
  end

  get '/user/:id/edit' do
    @user = find_user(:id, params[:id])
    if_user_display_access_error
    erb :'user/edit'
  end

  patch '/user/:id/edit' do
    error_if_not_logged_in
    @user = find_user(:id, params[:id])
    opts = { first_name: params[:first_name],
             second_name: params[:second_name],
             username: params[:username] }

    update_user(@user, :'user/edit', opts, '/manage_users')
  end

  get '/user/:id/delete' do
    @user = find_user(:id, params[:id])
    @user_records = Records.where(:user_id => params[:id])

    if_user_display_access_error
    erb :'user/delete'
  end

  get '/user/:id/delete/with_records' do
    error_if_not_logged_in
    @user = find_user(:id, params[:id])
    @records = Records.where(:user_id => params[:id])
    username = @user.username

    @user.delete_with_records(@user, @records)

    p "#{username} user is deleted with records!"
    redirect to '/manage_users'
  end

  get '/user/:id/delete/with_records_transfer' do
    error_if_not_logged_in
    if_user_display_access_error
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
    if_user_display_access_error
    @user = find_user(:id, params[:id])
    @records = Records.where(:user_id => params[:id])
    erb :'user/delete_and_transfer_records_to_new'
  end

  post '/user/:id/delete/with_records_transfer_to_new_user' do
    p "User check id: #{params[:id]}"
    @user = find_user(:id, params[:id])

    error_if_not_logged_in
    @records = Records.where(:user_id => params[:id])
    opts = { first_name: params[:first_name],
             second_name: params[:second_name],
             username: params[:username],
             password: params[:password],
             password_confirmation: params[:password_confirmation],
             password_status: 'temporary' }

    @user.delete_with_records_transfer_to_new(@user, @records ,opts)
    redirect to '/manage_users'
  end
end
