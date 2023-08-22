require_relative '../helpers/spec_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require_relative '../../app/controllers/users_controller'

RSpec.describe '[Users API]' do
  include AuthHelper
  include LoggerHelper

  def app
    UsersController
  end

  describe 'GET user/:id/delete/with_records_transfer' do
    context 'when not authorised'
    context 'when authorised, with invalid user id'
    context 'when authorised, with valid user id'
    context 'when user'
  end

  describe 'POST user/:id/delete/with_records_transfer' do
    context 'when not authorised'
    context 'when authorised, with invalid user id, and valid selected_user id'
    context 'when authorised, with valid user id, and invalid selected_user id'
    context 'when authorised, with valid user id, and valid selected_user id'
    context 'when user'
  end
end
