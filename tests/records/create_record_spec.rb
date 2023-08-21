require_relative 'helpers/rs/spec_helper'
require_relative 'helpers/logs_helper'
require_relative '../app/controllers/sessions_controller'
require_relative '../app/controllers/records_controller'

RSpec.describe '[Records API]' do
  include AuthHelper
  include LoggerHelper

  def app
    RecordsController
  end

  describe 'GET /added_person_form' do
    context 'when authorised'
    context 'when authorised'
  end

  describe 'POST /create_person' do

    let(:random_name) { Faker::Name.first_name }
    let(:random_last_name) { Faker::Name.last_name }
    let(:city) { 'Fake City' }
    let(:random_dob) { Faker::Date.birthday }

    context 'when logged in, and with valid data' do
      before(:each) do
        clear_cookies
        log_new_record_info(random_name, random_last_name, city, random_dob)

        log_in('TestUser', 'Test123456!')
        last_request_log
        last_response_body_log

        post '/create_person',
             first_name: random_name,
             second_name: random_last_name,
             city: city,
             date_of_birth: random_dfb
      end

      it 'saves new record to records table' do
        expect(Records.all).to include Records.find_by(:first_name => random_name,
                                                       :second_name => random_last_name,
                                                       :city => city,
                                                       :date_of_birth => random_dfb)
      end

      it 'redirects to /people_list page after successful record save' do
        follow_redirect!
        expect(last_response.body).to include('Records List')
      end

      it 'response code is 302 Found (Temporary Redirect)' do
        expect(last_response.status).to eq 302
      end
    end

    context 'when logged in, with empty values' do
      it 'error messages are displayed'
    end

    context 'when not authorised, and with valid data' do
      it 'record is not saved to records table'
      it 'user is redirected to /start page'
    end
  end
end
