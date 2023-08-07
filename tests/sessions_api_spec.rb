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
      end

      it 'redirects to homepage' do
        expect(last_response.body).to include('My Home Page')
      end

      it 'response code is 200 OK' do
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
    before(:each) do
      clear_cookies #Clear the session
    end

    let(:last_response_log_message) { '------------------------------------------------------ Last response after sing up ------------------------------------------------------------' }
    let(:end_log_line) { '-----------------------------------------------------------------------------------------------------------------------------------------------' }
    let(:random_password) { Faker::Alphanumeric.alphanumeric(number: 10) }

    context 'when request with valid parameters values' do
      before(:each) do
        @username = Faker::Internet.unique.username
        p "------------------------------------------------------ User creds: #{@username}, #{random_password} ------------------------------------------------------"

        post '/sign_up', username: @username, password: random_password, first_name: 'Test', second_name: 'User'

        p last_response_log_message
        p last_response
        p end_log_line
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
        @username = 'TestUser'
        p "------------------------------------------------------ User creds: #{@username}, #{random_password} ------------------------------------------------------"

        post '/sign_up', username: @username, password: random_password, first_name: 'Test', second_name: 'User'

        p last_response_log_message
        p last_response
        p end_log_line
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
      before(:each) do
        @username = nil
        @password = nil
        p "------------------------------------------------------ User creds: nil, nil ------------------------------------------------------"

        post '/sign_up', username: @username, password: @password, first_name: nil, second_name: nil

        p last_response_log_message
        p last_response
        p end_log_line
      end

      it 'fields validation error messages are displayed' do
        expect(last_response.body).to include("Password can't be blank")
        expect(last_response.body).to include("Username can't be blank")
        expect(last_response.body).to include('Username username length should be 4-20 symbols')
        expect(last_response.body).to include("First name can't be blank")
        expect(last_response.body).to include("Second name can't be blank")
        expect(last_response.body).to include("Password can't be blank")
        expect(last_response.body).to include('Password password must have length from 6 to 15 sym.')
      end

      it 'response code is 200 OK' do
        expect(last_response.status).to eq 200
      end

      it 'user still on sign up page' do
        expect(last_response.body).to include('Registration form')
      end
    end
  end

  describe 'POST /log_in' do
    before(:all) do
      clear_cookies #Clear the session
    end

    let(:invalid_username) { 'Fake' }
    let(:invalid_password) { 'Fake123456!' }
    let(:valid_username) { 'TestUser' }
    let(:valid_password) { 'Test123456!' }

    context 'with valid users username and password' do
      before(:each) do
        log_in(valid_username, valid_password)
      end

      it 'redirects user to homepage' do
        follow_redirect!
        expect(last_response.body).to include('My Home Page')
        expect(last_request.path).to eq('/homepage')
      end

      it 'response code is 302 Temporary redirected' do
        expect(last_response.status).to eq 302
      end
    end

    context 'with invalid username and password' do
      before(:each) do
        log_in(invalid_username, invalid_password)
      end

      it 'error message "Invalid [username] username or [password] password!" is displayed' do
        expect(last_response.body).to include("Invalid #{invalid_username} username or #{invalid_password} password!")
      end

      it 'response code is 200 OK' do
        expect(last_response.status).to eq 200
      end

      it 'user still on log in page' do
        expect(last_response.body).to include('Log in')
      end
    end
  end

  describe '[GET /start]' do
    before(:each) do
      clear_cookies #Clear the session
    end

    context 'when logged in' do
      before(:each) do
        log_in('TestUser', 'Test123456!')

        get '/start'
      end

      it 'status code is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end

    context 'when not authorised' do
      before(:each) do
        get '/start'
      end

      it 'status code is 200' do
        expect(last_response.status).to eq 200
      end
    end
  end

  describe '[GET /log_out]' do

    let(:last_response_log_message) { '------------------------------------------------------ Last response ------------------------------------------------------------' }
    let(:end_log_line) { '-----------------------------------------------------------------------------------------------------------------------------------------------' }

    before(:each) do
      clear_cookies #Clear the session
      log_in('TestUser', 'Test123456!')

      get '/log_out'
    end

    it 'user is redirected to start page' do
      expect(last_response.body).to include('Hello 🌱, Do you have an account?')
    end

    it 'status code is 200 OK' do
      expect(last_response.status).to eq 200
    end

    it 'user can not access /homepage anymore and is redirected to start page' do
      get '/homepage'
      expect(last_response.body).to include('Hello 🌱, Do you have an account?')
    end
  end

  describe '[GET /homepage]' do

    let(:last_response_log_message) { '------------------------------------------------------ Last response ------------------------------------------------------------' }
    let(:end_log_line) { '-----------------------------------------------------------------------------------------------------------------------------------------------' }

    context 'when not authorised' do
      before(:each) do
        clear_cookies #Clear the session

        get '/homepage'
        p last_response_log_message
        p last_response
        p end_log_line
      end

      it 'user is redirected to start page' do
        expect(last_response.body).to include('Hello 🌱, Do you have an account?')
      end

      it 'status code is 200' do
        expect(last_response.status).to eq 200
      end
    end

    context 'when logged in' do
      before(:each) do
        clear_cookies #Clear the session
        log_in('TestUser', 'Test123456!')

        get '/homepage'
        p last_response_log_message
        p last_response
        p end_log_line
      end

      it 'response code is 200 OK' do
        expect(last_response.status).to eq 200
      end

      it 'user is redirected to homepage' do
        expect(last_response.body).to include('My Home Page')
        expect(last_request.path).to eq('/homepage')
      end
    end
  end
end
