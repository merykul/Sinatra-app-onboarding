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

  def app
    RecordsController
  end

  describe 'GET /people_list' do

    let(:not_authorised_error) { data['not-authorised-error'] }
    let(:records_list_page_header) { data['records-list-page-title'] }

    context 'when not authorised' do
      before(:each) do
        clear_cookies

        get '/people_list'
      end

      it 'redirects to "Not authorised" error page' do
        expect(last_response.body).to include(not_authorised_error)
      end

      it 'response status is 401 Not Authorised' do
        expect(last_response.status).to eq 401
      end
    end

    context 'when logged in' do
      before(:each) do
        clear_cookies
        log_in('TestUser', 'Test123456!')

        get '/people_list'
      end

      it 'the list of all records is displayed' do
        expect(last_response.body).to include(records_list_page_header)
        expect(last_response.body).to include Records.all
      end

      it 'response status is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end

    context 'when city is defined'
  end
end
