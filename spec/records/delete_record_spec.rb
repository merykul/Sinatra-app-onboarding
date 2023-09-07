# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/models/records'
require_relative '../helpers/status_codes_shared_examples'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require_relative '../../app/controllers/users_controller'
require_relative '../../app/controllers/application_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Records API, delete record]' do
  include AuthHelper
  include LoggerHelper

  context 'when GET /records/:id/delete' do

    let(:random_fn) { Faker::Name.name }
    let(:random_sn) { Faker::Name.last_name }
    let(:record_access_error) { data['record_access_error'] }

    context 'when not authorised, with valid record id' do
      record = FactoryBot.create(:records)
      it_behaves_like 'not authorised get', "/records/#{record.id}/delete"
    end

    context 'when authorised, with invalid record id' do
      before(:all) { log_in('TestUser', 'Test123456!') }

      record = FactoryBot.create(:records)
      it_behaves_like 'get request with invalid data in the request url', "/records/#{record.id}/delete"
    end

    context 'when authorised, with valid record id' do
      before(:all) { log_in('TestUser', 'Test123456!') }

      record = FactoryBot.create(:records)
      it_behaves_like 'authorised get request', "/records/#{record.id}/delete" do
        let(:title) { data['delete_person_record_page_title'] }
      end

      it 'verifies that user accessed record information' do
        record = FactoryBot.create(:records)
        get "/records/#{record.id}/delete"
        expect(last_response.body).to include(record.first_name)
        expect(last_response.body).to include(record.second_name)
        expect(last_response.body).to include(record.city)
      end
    end

    context 'when authorised, with valid record id, and not matching user_id and current users id' do
      before(:all) { clear_cookies }

      it 'verifies that user can not access record' do
        record = FactoryBot.factories(:records)
        log_in('TestUser2', 'Test123456!')
        get "/records/#{record.id}/delete"
        expect(last_response.body).to include(record_access_error)
        expect(last_response.status).to eq 403
      end
    end

    # TODO, fix of the after section
    # after(:all) { FactoryBot.clear }
  end

  context 'when DELETE /records/:id/delete' do

    let(:page_not_found_error) { data['page_not_found_error'] }

    before(:each) { clear_cookies }

    context 'when not authorised' do
      before(:each) { clear_cookies }
      record = FactoryBot.factories(:records)

      it_behaves_like 'not authorised delete', "records/#{record.id}/delete"
    end

    context 'when authorised, with invalid record id' do
      before(:all) { log_in('TestUser', 'Test123456!') }
      record = FactoryBot.factories(:records)

      it 'verifies that invalid request page is rendered' do
        delete  "/records/19790/delete"
        expect(last_response.status).to eq 404
        expect(last_response.body).to include(page_not_found_error)
      end
    end

    context 'when authorised, with valid record id' do
      before(:all) { log_in('TestUser', 'Test123456!') }
      record1 = FactoryBot.factories(:records)

      it_behaves_like 'authorised delete', "records/#{record1.id}/delete"

      it 'verifies that record is deleted from the records table' do
        record = FactoryBot.factories(:records)
        delete "records/#{record.id}/delete"
        expect(Records.all).to_not include(record)
      end
    end

    context 'authorised, with valid record id, and not matching user_id and current users id' do
      before(:all) { clear_cookies }

      it 'verifies that record is not deleted from records table' do
        record = FactoryBot.factories(:records)
        log_in('TestUser2', 'Test123456!')
        delete "/records/#{record.id}/delete"
        expect(Records.all).to include(record)
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
end
