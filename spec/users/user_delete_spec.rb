# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API, user delete]' do
  include AuthHelper
  include LoggerHelper

  context 'when GET /user/:id/delete'do
    context 'when not authorised'
    context 'when authorised'
    context 'when user'
    context 'when authorised, with invalid user id'
  end
end
