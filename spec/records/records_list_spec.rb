# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Records API, records list]' do
  include AuthHelper
  include LoggerHelper

    let(:not_authorised_error) { data['not_authorised_error'] }
    let(:records_list_page_header) { data['records_list_page_title'] }

    context 'when not authorised' do
      before(:all) { clear_cookies }

      it 'redirects to "Not authorised" error page' do
        get '/people_list'
        expect(last_response.body).to include(not_authorised_error)
        expect(last_response.status).to eq 401
      end
    end

    context 'when logged in' do
      before(:each) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
      end

      it 'the list of all records is displayed' do
        get '/people_list'
        expect(last_response.body).to include(records_list_page_header)
        expect(last_response.body).to include Records.all
      end

      it 'response status is 200 OK' do
        get '/people_list'
        expect(last_response.status).to eq 200
      end
    end

    context 'when city is defined' do
      before(:each) { log_in('TestUser', 'Test123456!') }

      let(:no_records_per_city_error) { data['no_records_per_city_error'] }

      it 'verifies that returned records have defined city' do
        get '/people_list', city: 'Ivano-Frankivsk'
        expect(last_response.body).to include Records.where(city => 'Ivano-Frankivsk')
      end

      it 'verifies request with invalid city' do
        get '/people_list', city: 'Invalid_fsdf39d'
        expect(last_response.body).to_not include Records.all
        expect(last_response.body).to include(no_records_per_city_error)
      end

      it 'verifies request with empty city parameter' do
        get '/people_list', city: ''
        expect(last_response.body).to include Records.all
      end
    end
end
