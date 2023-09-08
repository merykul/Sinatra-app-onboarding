# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../helpers/status_codes_shared_examples'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API, user creation]' do
  include AuthHelper
  include LoggerHelper

  context 'when GET /create_user' do
    context 'when not authorised' do
      before(:all) { clear_cookies }

      it_behaves_like 'not authorised get', '/create_user'
    end

    context 'when authorised' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end

      it_behaves_like 'authorised get request', '/create_user' do
        let(:title) { data['create_user_page_title'] }
      end
    end

    context 'when user' do
      before(:all) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
      end

      it_behaves_like 'GET request is prohibited for user', '/create_user'
    end
  end

  context 'when POST /create_user_form' do
    context 'when not authorised' do

      it 'verifies that Not Authorised error is displayed'
    end

    context 'when authorised, with invalid user parameters' do

      it 'verifies that response code is 400'

      it 'verifies that user is not created'

      it 'verifies that error messages are displayed'
    end

    context 'when authorised, with valid user parameters' do

      it 'verifies that user is created successfully'

      it 'verifies that success message is rendered'
    end

    context 'when user' do

      it 'verifies that access for user is prohibited'

      it 'verifies that user is not created'
    end
  end
end
