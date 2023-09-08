# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../factories/users'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API, user delete]' do
  include AuthHelper
  include LoggerHelper

  context 'when GET /user/:id/delete'do

    context 'when not authorised' do
      before(:all) do
        clear_cookies
      end
      user = FactoryBot.create(:user)

      it_behaves_like 'not authorised get', "/user/#{user.id}/delete"

      after(:all) { user.delete }
    end

    context 'when authorised, with valid user id' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end
      user = FactoryBot.create(:user)

      it_behaves_like 'authorised get request', "/user/#{user.id}/delete" do
        let(:title) { data['delete_user_page_title'] }
      end

      after(:all) { user.delete }
    end

    context 'when user' do
      before(:all) do
        clear_cookies
        log_in('TestUser', 'Test123456!')
      end
      user = FactoryBot.create(:user)

      it_behaves_like 'GET request is prohibited for user', "/user/#{user.id}/delete"

      after(:all) { user.delete }
    end

    context 'when authorised, with invalid user id' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end

      it_behaves_like 'get request with invalid data in the request url', "/user/04398/delete"
    end
  end
end
