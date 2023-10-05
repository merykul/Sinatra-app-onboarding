require_relative '../helpers/spec_helper'
# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API, edit user]' do
  include AuthHelper
  include LoggerHelper

  context 'when GET /user/:id/edit' do

    context 'when not authorised' do
      before(:all) do
        clear_cookies
      end
      user = FactoryBot.factories(:user)

      it_behaves_like 'not authorised get', "/user/#{user.id}/edit"

      after(:all) { user.delete }
    end

    context 'when authorised, with invalid user id' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end

      it_behaves_like 'get request with invalid data in the request url', "/user/04398/edit"

      after(:all) { user.delete }
    end

    context 'when authorised, with valid user id' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end
      user = FactoryBot.factories(:user)

      it_behaves_like 'authorised get request', "/user/#{user.id}/edit"

      after(:all) { user.delete }
    end

    context 'when user' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end
      user = FactoryBot.factories(:user)

      it_behaves_like 'GET request is prohibited for user', "/user/#{user.id}/edit"

      after(:all) { user.delete }
    end
  end

  context 'when PATCH /user/:id/edit' do
    context 'when not authorised'
    context 'when authorised'
    context 'when authorised, with invalid user id, and valid users parameters'
    context 'when authorised, with valid user id, and invalid users parameters'
    context 'when authorised, with valid user id, and valid users parameters'
    context 'when user'
  end
end
