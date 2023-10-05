# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Records API, edit]' do
  include AuthHelper
  include LoggerHelper

  let(:record_access_error) { data['record_access_error'] }

  context 'when GET /records/:id/edit' do
    context 'when not authorised' do
      before(:all) { clear_cookies }
      record = FactoryBot.create(:records)

      it_behaves_like 'not authorised get', "/records/#{record.id}/edit"
    end

    context 'when authorised, with valid record id' do
      before(:each) do
        clear_cookies
        log_in('TestUser' ,'Test123456!')
      end
      record = FactoryBot.create(:records)

      it_behaves_like 'authorised get', "/records/#{record.id}/edit" do
        let(:title) { data['edit_person_record_page_title'] }
      end
    end

    context 'when authorised, with invalid record id' do
      before(:all) do
        clear_cookies
        log_in('TestUser' ,'Test123456!')
      end
      record = FactoryBot.create(:records)

      it_behaves_like 'get request with invalid data in the request url', "/records/#{record.id}/edit"
    end

    context 'when authorised, with valid record id, and not matching user_id and current users id' do
      before(:all) do
        clear_cookies
        log_in('TestUser' ,'Test123456!')
      end

      it 'verifies that user can not access record' do
        record = FactoryBot.factories(:records)
        log_in('TestUser2', 'Test123456!')
        delete "/records/#{record.id}/delete"
        expect(last_response.body).to include(record_access_error)
        expect(last_response.status).to eq 403
      end
    end
  end

  context 'when PATCH /records/:id/edit' do
    context 'when not authorised'
    context 'when logged in, with valid data'
    context 'when logged in, with empty parameters'
    context 'when logged in with invalid record id'
  end
end
