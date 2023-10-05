# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API, deletion with records]' do
  include AuthHelper
  include LoggerHelper

  context 'when DELETE /user/:id/delete/with_records' do

    context 'when not authorised' do
      before(:all) { clear_cookies }
      user = FactoryBot.create(:user)

      it_behaves_like 'not authorised delete', "/user/#{user.id}/delete/with_records"

      it 'verifies that user is not deleted' do
        delete "/user/#{user.id}/delete/with_records"
        expect(User.all).to include User.find_by(id => user.id)
      end

      after(:all) { user.delete }
    end

    context 'when authorised, with invalid user id in the url' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end

      it_behaves_like 'DELETE request with invalid data in the request url', "/user/03829/delete/with_records"
    end

    context 'when authorised, with valid user id' do
      before(:all) do
        clear_cookies
        log_in('TestAdmin', 'Test123456!')
      end
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)

      it_behaves_like 'authorised delete', "/user/#{user1.id}/delete/with_records" do
        let(:successful_delete_message) { data['successful_user_deletion_with_records_message'] }
      end

      it 'verifies that user is deleted successfully with records' do
        delete "/user/#{user2.id}/delete/with_records"
        expect(Records.all).to_not include Records.where(user_id => user2.id)
        expect(User.all).to_not include User.where(id => user2.id)
      end
    end
  end
end
