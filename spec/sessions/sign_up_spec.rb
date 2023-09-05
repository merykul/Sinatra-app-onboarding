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

  context 'when GET /sign_up_form' do
    context 'when authorised' do
      before(:all) { log_in('TestUser', 'Test123456!') }

      it_behaves_like 'authorised get request', '/homepage' do
        let(:title) { data['homepage_header'] }
      end
    end

    context 'when not authorised' do
      it_behaves_like 'authorised get request', '/sign_up_form' do
        let(:title) { data['registration_page_header'] }
      end
    end
  end

  context 'when POST /sign_up' do
    before(:each) { clear_cookies }

    let(:random_password) { Faker::Alphanumeric.alphanumeric(number: 10) }
    let(:homepage_header) { data['homepage_header'] }
    let(:not_authorised_error) { data['not_authorised_error'] }
    let(:username_taken_error) { data['username_taken_error'] }
    let(:registration_page_header) { data['registration_page_header'] }
    let(:invalid_username_and_password) { data['invalid_username_or_password_error'] }
    let(:blank_password_error) { data['blank_password_error'] }
    let(:blank_first_name_error) { data['blank_first_name_error'] }
    let(:blank_second_name_error) { data['blank_second_name_error'] }
    let(:blank_username_error) { data['blank_username_error'] }
    let(:username_length_error) { data['username_length_error'] }
    let(:password_length_error) { data['password_length_error'] }
    let(:blank_password_confirmation_error) { data['blank_password_confirmation_error'] }

    context 'when request with valid parameters values' do
      before(:each) do
        @username = Faker::Internet.unique.username
        user_creds_log(@username, random_password)

        post '/sign_up', username: @username, password: random_password, first_name: 'Test', second_name: 'User'

        last_response_log
      end

      it 'verifies that user is created' do
        expect(User.all).to include User.find_by(:username => @username)
      end

      it 'verifies that user is redirected to homepage' do
        expect(last_response.body).to include(homepage_header)
        expect(last_request.path).to eq('/homepage')
      end

      it 'verifies that response code is 201 Created' do
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

      it 'verifies that "Username has already been taken" error message is displayed' do
        expect(last_response.body).to include(username_taken_error)
      end

      it 'verifies that duplicated user is not saved to users table' do
        expect(User.where(:username => @username).count).to eq(1)
      end

      it 'verifies that response code is 400' do
        expect(last_response.status).to eq 400
      end
    end

    context 'when parameters are empty' do

      let(:errors) {  [
        blank_password_error,
        blank_username_error,
        username_length_error,
        blank_first_name_error,
        blank_second_name_error,
        blank_password_error,
        blank_password_confirmation_error,
        password_length_error
      ] }

      before(:each) do
        @username = nil
        @password = nil
        user_creds_log('nil', 'nil')

        post '/sign_up', username: @username, password: @password, first_name: nil, second_name: nil

        last_response_log
      end

      it 'verifies that fields validation error messages are displayed' do
        errors.each do |error|
          expect(last_response.body).to include(error)
        end
      end

      it 'verifies that response code is 400' do
        expect(last_response.status).to eq 400
      end

      it 'verifies that user still on sign up page' do
        expect(last_response.body).to include(registration_page_header)
      end
    end
  end
end
