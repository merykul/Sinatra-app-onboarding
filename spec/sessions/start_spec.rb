# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../helpers/status_codes_shared_examples'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Sessions API]' do
  include AuthHelper
  include LoggerHelper

  describe '[GET /start]' do
    before(:each) { clear_cookies }

    context 'when authorised' do
      before(:each) { log_in('TestUser', 'Test123456!') }

      it_behaves_like 'authorised get request', '/start' do
        let(:title) { data['start_page_header'] }
      end
    end

    context 'when not authorised' do

      it_behaves_like 'authorised get request', '/start' do
        let(:title) { data['start_page_header'] }
      end
    end
  end
end
