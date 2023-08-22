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

  def app
    UsersController
  end

  describe 'GET /user/:id/set_password' do
    context 'when not authorised'
    context 'when authorised'
  end

  describe 'PATCH /user/:id/set_password' do
    context 'when not authorised'
    context 'when authorised, with invalid username and password'
    context 'when authorised, with valid username and password'
  end
end
