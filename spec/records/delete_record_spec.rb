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

RSpec.describe '[Records API]' do
  include AuthHelper
  include LoggerHelper

  def app
    Rack::Builder.new do
      run ApplicationController
      use RecordsController
      use SessionsController
      use UsersController
    end.to_app
  end

  describe 'GET /records/:id/delete' do

    let(:random_fn) { Faker::Name.name }
    let(:random_sn) { Faker::Name.last_name }

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
        let(:title) { data['delete-person-record-page-title'] }
      end

      xit 'user accessed record information' do
        record = FactoryBot.create(:records)
        get "/records/#{record.id}/delete"
        expect(last_response.body).to include(record.first_name)
        expect(last_response.body).to include(record.second_name)
        expect(last_response.body).to include(record.city)
      end
    end

    # after(:all) { @record.destroy! }
  end

  describe 'DELETE /records/:id/delete' do
    context 'when not authorised'
    context 'when logged in with invalid record id'
    context 'when logged in'
  end
end
