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

  context 'when GET /log_out' do

    let(:start_page_header) { data['start-page_header'] }

    before(:each) do
      clear_cookies
      log_in('TestUser', 'Test123456!')
    end

    get '/log_out'

    it 'verifies that user is redirected to start page' do
      expect(last_response.body).to include(start_page_header)
    end

    it 'verifies that status code is 200 OK' do
      expect(last_response.status).to eq 200
    end

    it 'verifies that user can not access homepage anymore and is redirected to start page' do
      get '/homepage'
      expect(last_response.body).to include(start_page_header)
    end
  end
end
