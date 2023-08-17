# frozen_string_literal: true
require_relative 'helpers/spec_helper'
require_relative '../app/controllers/sessions_controller'
require_relative '../app/controllers/records_controller'

RSpec.describe '[Log in API]' do
  include AuthHelper
  include LoggerHelper

  def app
    SessionsController
  end

  describe 'GET /log_in_form' do
    context 'when logged in' do
      before(:each) do
        clear_cookiess
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
        clear_cookies
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

  describe 'POST /log_in' do
    before(:all) do
      clear_cookies
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
end
