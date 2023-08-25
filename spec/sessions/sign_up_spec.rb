# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Sessions API]' do
  include AuthHelper
  include LoggerHelper

  def app
    Rack::Builder.new do
      run ApplicationController
      use RecordsController
      use SessionsController
      use UsersController
    end.to_app
  end

  describe 'GET /sign_up_form' do
    context 'with valid new user parameters'
    context 'with invalid new user parameters'
  end

  describe 'POST /sign_up' do
    before(:each) { clear_cookies }

    let(:random_password) { Faker::Alphanumeric.alphanumeric(number: 10) }
    let(:homepage_header) { data['homepage-header'] }
    let(:not_authorised_error) { data['not-authorised-error'] }
    let(:username_taken_error) { data['username-taken-error'] }
    let(:registration_page_header) { data['registration_page_header'] }
    let(:invalid_username_and_password) { data['invalid-username-or-password-error'] }
    let(:blank_password_error) { data['blank-password-error'] }
    let(:blank_first_name_error) { data['blank-first-name-error'] }
    let(:blank_second_name_error) { data['blank-second-name-error'] }
    let(:blank_username_error) { data['blank-username-error'] }
    let(:username_length_error) { data['username-length-error'] }
    let(:password_length_error) { data['password-length-error'] }
    let(:blank_password_confirmation_error) { data['blank-password-confirmation-error'] }

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
        expect(last_response.body).to include(homepage_header)
        expect(last_request.path).to eq('/homepage')
      end

      it 'response code is 201 Created' do
        expect(last_response.status).to eq 201
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
        expect(last_response.body).to include(username_taken_error)
      end

      it 'duplicated user is not saved to users table' do
        expect(User.where(:username => @username).count).to eq(1)
      end

      it 'response code is 400' do
        expect(last_response.status).to eq 400
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
        expect(last_response.body).to include(blank_password_error)
        expect(last_response.body).to include(blank_username_error)
        expect(last_response.body).to include(username_length_error)
        expect(last_response.body).to include(blank_first_name_error)
        expect(last_response.body).to include(blank_second_name_error)
        expect(last_response.body).to include(blank_password_error)
        expect(last_response.body).to include(blank_password_confirmation_error)
        expect(last_response.body).to include(password_length_error)
      end

      it 'response code is 400' do
        expect(last_response.status).to eq 400
      end

      it 'user still on sign up page' do
        expect(last_response.body).to include(registration_page_header)
      end
    end
  end
end
