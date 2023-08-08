require_relative './application_controller'

class UsersController < ApplicationController

  get '/create_user' do
    if current_user.role == 'admin'
      erb :'user/create'
    else
      erb :'errors/users_profiles_access_error'
    end
  end

  post '/create_user_form' do

  end

  get '/user/:id/edit' do
    if current_user.role == 'admin'
      erb :'user/edit'
    else
      erb :'errors/users_profiles_access_error'
    end
  end

  patch '/user/:id/edit' do

  end

  get '/user/:id/delete' do
    if current_user.role == 'admin'
      erb :'user/delete'
    else
      erb :'errors/users_profiles_access_error'
    end
  end

  delete '/user/:id/delete' do

  end
end
