require_relative '../helpers/spec_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require_relative '../../app/controllers/users_controller'

RSpec.describe '[Users API, user creation]' do
  include AuthHelper
  include LoggerHelper

  def app
    UsersController
  end

  describe 'GET /create_user' do
    context 'when not authorised'
    context 'when authorised'
    context 'when user'
  end

  describe 'POST /create_user_form' do
    context 'when not authorised'
    context 'when authorised, with invalid user parameters'
    context 'when authorised, with valid user parameters'
    context 'when user'
  end
end