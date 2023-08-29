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

  describe '[GET /start]' do
    before(:each) { clear_cookies }

    context 'when logged in' do
      before(:each) { log_in('TestUser', 'Test123456!') }

      get '/start'

      it 'status code is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end

    context 'when not authorised' do

      get '/start'

      it 'status code is 200' do
        expect(last_response.status).to eq 200
      end
    end
  end
end
