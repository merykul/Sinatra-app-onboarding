# frozen_string_literal: true
require_relative 'helpers/spec_helper'
require_relative '../app/controllers/sessions_controller'
require_relative '../app/controllers/records_controller'

RSpec.describe '[Session API]' do
  include AuthHelper
  include LoggerHelper

  def app
    SessionsController
  end

  describe '[GET /homepage]' do
    context 'when not authorised' do
      before(:all) do
        clear_cookies
        get '/homepage'
        last_response_log
      end

      it 'user is redirected to start page' do
        expect(last_response.body).to include('Hello 🌱, Do you have an account?')
      end

      it 'status code is 401 Not Authorised' do
        expect(last_response.status).to eq 401
      end
    end

    context 'when logged in' do
      before(:all) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
        get '/homepage'
        last_response_log
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
