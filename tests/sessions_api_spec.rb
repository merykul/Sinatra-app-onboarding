require_relative 'helpers/spec_helper'
require_relative '../app/controllers/sessions_controller'
require_relative '../app/controllers/records_controller'
require 'faker'

RSpec.describe '[Sessions API]' do
  include AuthHelper

  def app
    SessionsController
  end

  describe 'GET /log_in_form' do
    context 'when logged in' do
      before(:each) do
        clear_cookies #Clear the session
        log_in('TestUser', 'Test123456!')

        get '/log_in_form'
        follow_redirect!
      end

      it 'redirects to homepage' do
        expect(last_request.path).to eq('/homepage')
        expect(last_response.status).to eq 200
      end
    end

    context 'when not logged in' do
      before(:each) do
        clear_cookies #Clear the session
        get '/log_in_form'
      end

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
      before(:each) do
        clear_cookies #Clear the session
        @username = Faker::Internet.unique.username
        @password = Faker::Alphanumeric.alphanumeric(number: 10)
        p "------------------------ New user creds: #{@username}, #{@password} ------------------------"

        post '/sign_up', username: @username, password: @password, first_name: 'Test', second_name: 'User'

        p '------------------------ Last response after sing up ------------------------------'
        p last_response
        p '-----------------------------------------------------------------------------------'
      end

      it 'user is created' do
        expect(User.all).to include User.find_by(:username => @username)
      end

      it 'user is redirected to homepage' do
        follow_redirect!
        expect(last_response.body).to include('My Home Page')
        expect(last_request.path).to eq('/homepage')
      end

      it 'response code is 302 Found (Temporary Redirect)' do
        expect(last_response.status).to eq 302
      end
    end

    context 'when username already exists' do
      before(:each) do
        clear_cookies #Clear the session
        @username = 'TestUser'
        @password = Faker::Alphanumeric.alphanumeric(number: 10)
        p "------------------------ User creds: #{@username}, #{@password} ------------------------"

        post '/sign_up', username: @username, password: @password, first_name: 'Test', second_name: 'User'

        p '------------------------ Last response after sing up ------------------------------'
        p last_response
        p '-----------------------------------------------------------------------------------'
      end

      it 'displays "Username has already been taken" error message' do
        expect(last_response.body).to include('Username has already been taken')
      end

      it 'duplicated user is not saved to users table' do
        expect(User.where(:username => @username).count).to eq(1)
      end

      it 'response code is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end

    context 'when parameters are empty' do
      it 'fields validation error messages are displayed'
      it 'response code is 200 OK, and user still on sign up page'
    end
  end

  describe 'POST /log_in' do
    before(:all) do
      clear_cookies #Clear the session
    end

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
      before(:all) do
        clear_cookies #Clear the session
      end

      it 'status code is 200'
    end
  end

  describe 'GET /log_out' do
    it 'user is redirected to start page'
    it 'status code is 200'
  end

  describe 'GET /homepage' do
    context 'when not authorised' do
      before(:all) do
        clear_cookies #Clear the session
      end

      it 'user is redirected to log in page'
      it 'status code is 200'
    end

    context 'when logged in' do
      it 'status code is 200'
      it 'user is redirected to homepage'
    end
  end
end
