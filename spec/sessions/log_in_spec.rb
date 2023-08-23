# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Log in API]' do
  include AuthHelper
  include LoggerHelper

  def app
    SessionsController
  end

  describe 'GET /log_in_form' do

    let(:homepage_header) { data['homepage-header'] }
    let(:log_in_page_header) { data['log-in-page-header'] }

    context 'when logged in' do
      before(:each) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
      end

        get '/log_in_form'
      end

      it 'redirects to homepage' do
        expect(last_response.body).to include(homepage_header)
      end

      it 'response code is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end

    context 'when not logged in' do
      before(:each) { clear_cookies }

      get '/log_in_form'

      it 'redirects to login page' do
        expect(last_response.body).to include(log_in_page_header)
      end

      it 'response code is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end
  end

  describe 'POST /log_in' do
    before(:all) { clear_cookies }

    let(:invalid_username) { 'Fake' }
    let(:invalid_password) { 'Fake123456!' }
    let(:valid_username) { 'TestUser' }
    let(:valid_password) { 'Test123456!' }
    let(:homepage_header) { data['homepage-header'] }
    let(:log_in_page_header) { data['log-in-page-header'] }
    let(:invalid_username_or_password_error) { data['invalid-username-or-password-error'] }

    context 'with valid users username and password' do
      before(:each) { log_in(valid_username, valid_password) }

      it 'redirects user to homepage' do
        follow_redirect!
        expect(last_response.body).to include(homepage_header)
        expect(last_request.path).to eq('/homepage')
      end

      it 'response code is 200 OK' do
        expect(last_response.status).to eq 200
      end
    end

    context 'with invalid username and password' do
      before(:each) { log_in(invalid_username, invalid_password) }

      it 'error message is displayed' do
        expect(last_response.body).to include(invalid_username_or_password_error)
      end

      it 'response code is 400' do
        expect(last_response.status).to eq 400
      end

      it 'user still on log in page' do
        expect(last_response.body).to include(log_in_page_header)
      end
    end
  end
end
