# frozen_string_literal: true
require_relative 'helpers/rs/spec_helper'
require_relative '../app/controllers/sessions_controller'
require_relative '../app/controllers/records_controller'

RSpec.describe '[Sessions API]' do
  include AuthHelper
  include LoggerHelper

  def app
    SessionsController
  end

  describe 'GET /sign_up_form' do
    context 'with valid new user parameters'
    context 'with invalid new user parameters'
  end

  describe 'POST /sign_up' do
    before(:each) do
      clear_cookies
    end

    let(:random_password) { Faker::Alphanumeric.alphanumeric(number: 10) }

    context 'when request with valid parameters values' do
      before(:each) do
        @username = Faker::Internet.unique.username
        user_creds_log(@username, random_password)

        post '/sign_up', username: @username, password: random_password, first_name: 'Test', second_name: 'User'

        last_response_log
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
        user_creds_log(@username, random_password)
        post '/sign_up', username: @username, password: random_password, first_name: 'Test', second_name: 'User'

        last_response_log
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
        user_creds_log('nil', 'nil')

        post '/sign_up', username: @username, password: @password, first_name: nil, second_name: nil

        last_response_log
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
end
