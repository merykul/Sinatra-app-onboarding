# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API, delete with records transfer]' do
  include AuthHelper
  include LoggerHelper

  context 'when GET user/:id/delete/with_records_transfer' do

    context 'when not authorised' do
      before(:all) do
        clear_cookies
      end
      user = FactoryBot.factories(:user)

      it_behaves_like 'not authorised get', "/user/#{user.id}/delete/with_records_transfer"

      after(:all) { user.delete }
    end

    context 'when authorised, with invalid user id' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end

      it_behaves_like 'get request with invalid data in the request url', "/user/93238/delete/with_records_transfer"
    end

    context 'when authorised, with valid user id' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end
      user = FactoryBot.factories(:user)

      it_behaves_like 'authorised get request', "/user/#{user.id}/delete/with_records_transfer"
    end

    context 'when user' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end
      user = FactoryBot.factories(:user)

      it_behaves_like 'GET request is prohibited for user', "/user/#{user.id}/delete/with_records_transfer"
    end
  end

  context 'when POST user/:id/delete/with_records_transfer' do

    context 'when not authorised' do
      before(:all) { clear_cookies }
      user = FactoryBot.factories(:user)
      user_to_accept_records = FactoryBot.factories(:user)

      it 'verifies that Not Authorised error page is rendered', ""

      it 'verifies that user is not deleted and records are not transferred'
    end

    context 'when authorised, with invalid user id, and valid selected_user id'

    context 'when authorised, with valid user id, and invalid selected_user id'

    context 'when authorised, with valid user id, and valid selected_user id'

    context 'when user'
  end
end
