# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API, set password]' do
  include AuthHelper
  include LoggerHelper

  context 'when GET /user/:id/set_password' do

    context 'when not authorised' do
      before(:all) do
        clear_cookies
      end
      user = FactoryBot.factories(:user)

      it_behaves_like 'not authorised get', "/user/#{user.id}/set_password"

      after(:all) { user.delete }
    end

    context 'when authorised, with valid user id' do
      before(:all) do
        clear_cookies
        # DRAFT >>>>>>>>>>>>>>>>>>>>>>>>>>>
        user = FactoryBot.factories(:user)
        log_in(user.username, user.password)
        # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      end

      it_behaves_like 'authorised get request', "/user/#{user.id}/set_password" do
        let(:title) { data['set_password_page_title'] }
      end

      after(:all) { user.delete }
    end

    context 'when authorised, with invalid user id' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end

      it_behaves_like 'get request with invalid data in the request url', "/user/04398/set_password"
    end

    after(:all) { user.delete }
  end

  context 'when PATCH /user/:id/set_password' do
    context 'when not authorised'
    context 'when authorised, with invalid username and password'
    context 'when authorised, with valid username and password'
  end
end
