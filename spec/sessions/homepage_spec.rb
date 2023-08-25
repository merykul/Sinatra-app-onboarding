# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Session API]' do
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

  describe '[GET /homepage]' do

    let(:homepage_header) { data['homepage-header'] }
    let(:not_authorised_error) { data['not-authorised-error'] }

    context 'when not authorised' do
      before(:all) { clear_cookies }

      it 'user is redirected to "Not authorised" error page' do
        get '/homepage'
        expect(last_response.body).to include(not_authorised_error)
        expect(last_response.status).to eq 401
      end
    end

    context 'when logged in' do
      before(:all) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
      end

      it 'response code is 200 OK' do
        get '/homepage'
        expect(last_response.status).to eq 200
      end

      it 'user is redirected to homepage' do
        get '/homepage'
        last_response_log
        expect(last_response.body).to include(homepage_header)
        expect(last_request.path).to eq('/homepage')
      end
    end
  end
end
