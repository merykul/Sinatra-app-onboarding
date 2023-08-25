# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/models/city'
require_relative '../helpers/status_codes_shared_examples'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require_relative '../../app/controllers/users_controller'
require_relative '../../app/controllers/application_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Records API, cities statistics]' do
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

  describe 'GET /cities_statistics' do
    context 'when authorised' do
      before(:each) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
        last_response_status
        last_response_body_log
    end

      it_behaves_like 'authorised get request', '/cities_statistics' do
        let(:title) { data['cities-statistics-page-title'] }
      end

      it 'user accessed cities statistics page and data' do
        get '/cities_statistics'
        City.all.each do |city|
          expect(last_response.body).to include(city.city)
        end
      end
    end

    context 'when not authorised' do
      before(:all) { clear_cookies }

      it_behaves_like 'not authorised get', '/cities_statistics'
    end
  end
end
