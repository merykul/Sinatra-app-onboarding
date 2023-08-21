require_relative 'helpers/rs/spec_helper'
require_relative 'helpers/logs_helper'
require_relative '../app/controllers/sessions_controller'
require_relative '../app/controllers/records_controller'

RSpec.describe '[Records API, records list]' do
  include AuthHelper
  include LoggerHelper

  def app
    RecordsController
  end

  describe 'GET /people_list' do
    context 'when not authorised' do
      before(:each) do
        clear_cookies

        get '/people_list'
      end

      it 'redirects to start page' do
        expect(last_response.body).to include('Hello 🌱, Do you have an account?')
      end

      it 'response status is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end

    context 'when logged in' do
      before(:each) do
        clear_cookies
        log_in('TestUser', 'Test123456!')

        get '/people_list'
      end

      it 'the list of all records is displayed' do
        expect(last_response.body).to include('Records List')
        expect(last_response.body).to include Records.all
      end

      it 'response status is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end

    context 'when city is defined'
  end
end
