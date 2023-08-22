# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API, manage users access]' do
  include AuthHelper
  include LoggerHelper

  def app
    UsersController
  end

  describe 'GET /manage_users' do
    context 'when authorised'
    context 'when not authorised'
    context 'when user'
  end
end
