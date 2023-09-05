# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API, user creation]' do
  include AuthHelper
  include LoggerHelper

  context 'when GET /create_user' do
    context 'when not authorised'
    context 'when authorised'
    context 'when user'
  end

  context 'when POST /create_user_form' do
    context 'when not authorised'
    context 'when authorised, with invalid user parameters'
    context 'when authorised, with valid user parameters'
    context 'when user'
  end
end
