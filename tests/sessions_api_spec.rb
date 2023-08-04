require_relative 'helpers/spec_helper'
require_relative '../app/controllers/sessions_controller'
require 'faker'

RSpec.describe 'Sessions API' do
  include AuthHelper

  def app
    SessionsController
  end

  describe 'GET /log_in_form' do
    context 'when logged in' do
      clear_cookies #Clear the session
      log_in('TestUser', 'Test123456!')

      get '/log_in_form'
      follow_redirect!

      it 'redirects to homepage' do
        expect(last_request.path).to eq('/homepage')
        expect(last_response.status).to eq 200
      end
    end

    context 'when not logged in' do
      get '/log_in_form'

      it 'redirects to login page' do
        expect(last_response.body).to include('Log in')
      end

      it 'response code is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end
  end

  describe 'POST /sign_up' do
    context 'when request with valid parameters values' do
      #Given
      username = Faker::Internet.unique.username
      password = Faker::Alphanumeric.alphanumeric(number: 10)

      #When
      post '/sign_up', username: username, password: password

      #Then
      it 'user is created' do

      end

      it 'user is redirected to homepage' do

      end

      it 'response code is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end

    context 'when user with such username already exists' do
      it 'displays "Username has already been taken" error message'
      it 'duplicated user is not saved to users table'
      it 'response code is 200 OK, and user still on sign up page'
    end

    context 'when parameters are empty' do
      it 'fields validation error messages are displayed'
      it 'response code is 200 OK, and user still on sign up page'
    end
  end

  describe 'POST /log_in' do
    context 'with valid users username and password' do
      it 'redirects user to homepage'
      it 'response code is 200 OK'
    end

    context 'with invalid username and password' do
      it 'error message "Invalid [username] username or [password] password!" is displayed'
      it 'response code is 200 OK, and user is redirected to log in page again'
    end
  end

  describe 'GET /start' do
    context 'when logged in' do
      it 'status code is 200 OK'
    end

    context 'when not authorised' do
      it 'status code is 200'
    end
  end

  describe 'GET /log_out' do
    it 'user is redirected to start page'
    it 'status code is 200'
  end

  describe 'GET /homepage' do
    context 'when not authorised' do
      it 'user is redirected to log in page'
      it 'status code is 200'
    end

    context 'when logged in' do
      it 'status code is 200'
      it 'user is redirected to homepage'
    end
  end
end
