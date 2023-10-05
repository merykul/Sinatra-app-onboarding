# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API, manage users access]' do
  include AuthHelper
  include LoggerHelper

  context 'when GET /manage_users' do

    context 'when authorised' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
        last_response_status
        last_response_body_log
      end

      it_behaves_like 'authorised get request', '/manage_users' do
        let(:title) { data['user_management_page_title'] }
      end
    end

    context 'when not authorised' do
      before(:all) { clear_cookies }

      it_behaves_like 'not authorised get', '/manage_users'
    end

    context 'when user' do
      before(:all) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
      end

      it_behaves_like 'GET request is prohibited for user', '/manage_users'
    end
  end
end
