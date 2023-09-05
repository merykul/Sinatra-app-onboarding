# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../helpers/status_codes_shared_examples'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require_relative '../../app/controllers/users_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Records API, record creation]' do
  include AuthHelper
  include LoggerHelper

  context 'when GET /added_person_form' do

    let(:create_person_page_title) { data['create_person_page_title'] }

    context 'when authorised' do
      before(:all) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
      end

      it 'redirects user to record creation page' do
        get '/added_person_form'
        expect(last_response.body).to include(create_person_page_title)
      end

      it_behaves_like 'authorised get request', '/added_person_form' do
        let(:title) { data['create_person_page_title'] }
      end
    end

    context 'when not authorised' do
      it_behaves_like 'not authorised get', '/added_person_form'
    end
  end

  context 'when POST /create_person' do

    let(:random_name) { Faker::Name.first_name }
    let(:random_last_name) { Faker::Name.last_name }
    let(:city) { 'Fake City' }
    let(:random_dob) { Faker::Date.birthday }
    let(:records_list_page_header) { data['records-list-page-title'] }
    let(:blank_first_name_error) { data['blank-first-name-error'] }
    let(:blank_second_name_error) { data['blank-second-name-error'] }
    let(:city_length_error) { data['city-length-error'] }
    let(:blank_city_error) { data['blank-city-error'] }
    let(:not_authorised_page_header) { data['not-authorised-error'] }

    context 'when authorised, and with valid data' do
      before(:each) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
        last_response_log
        log_new_record_info(random_name, random_last_name, city, random_dob)
      end

      it 'saves new record to records table' do
        post '/create_person',
             first_name: random_name,
             second_name: random_last_name,
             city: city,
             date_of_birth: random_dob

        expect(Records.all).to include Records.find_by(:first_name => random_name,
                                                       :second_name => random_last_name,
                                                       :city => city,
                                                       :date_of_birth => random_dob)
      end

      it 'redirects to /people_list page after successful record save' do
        post '/create_person',
             first_name: random_name,
             second_name: random_last_name,
             city: city,
             date_of_birth: random_dob

        expect(last_response.body).to include(records_list_page_header)
      end

      # TODO
      # it_behaves_like 'successful post request', '/create_person' do
      #   first_name = random_name
      #   second_name = random_last_name
      #   address = city
      #   date_of_birth = random_dob
      # end
    end

    context 'when authorised, with empty values' do
      before(:all) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
        last_request_log
        last_response_body_log
      end

      it 'error messages are displayed and response status code is 400' do
        log_new_record_info(random_name, random_last_name, city, random_dob)
        post '/create_person',
             first_name: '',
             second_name: '',
             city: '',
             date_of_birth: ''
        expect(last_response.body).to include(blank_first_name_error)
        expect(last_response.body).to include(blank_second_name_error)
        expect(last_response.body).to include(blank_city_error)
        expect(last_response.body).to include(city_length_error)
        expect(last_response.status).to eq 400
      end
    end

    context 'when not authorised, and with valid data' do
      before(:all) { clear_cookies }

      it 'record is not saved to records table' do
        post '/create_person',
             first_name: random_name,
             second_name: random_last_name,
             city: city,
             date_of_birth: random_dob
        expect(Records.all).to_not include Records.find_by(:first_name => random_name,
                                                           :second_name => random_last_name,
                                                           :city => city,
                                                           :date_of_birth => random_dob)
      end

      it_behaves_like 'unauthorised post request', '/create_person'
    end
  end
end
