# frozen_string_literal: true
require_relative 'helpers/spec_helper'
require_relative '../app/controllers/sessions_controller'
require_relative '../app/controllers/records_controller'

RSpec.describe '[Sessions API]' do
  include AuthHelper
  include LoggerHelper

  def app
    SessionsController
  end

  describe '[GET /log_out]' do
    before(:each) do
      clear_cookies
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
end
