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

  context 'when DELETE user/:id/delete/with_records' do
    context 'when not authorised' do

      it 'verifies that Not authorised error page is rendered'

      it 'verifies that user is not deleted'
    end

    context 'when authorised, with invalid user id in the url' do

      it 'verifies that 404 Not Found error page is rendered'
    end

    context 'when authorised, with valid user id' do

      it 'verifies that user is deleted successfully with records'

      it 'verifies that success message is displayed'
    end
  end
end
