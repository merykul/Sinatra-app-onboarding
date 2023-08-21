require_relative '../helpers/spec_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require_relative '../../app/controllers/users_controller'

RSpec.describe '[Users API, edit user]' do
  include AuthHelper
  include LoggerHelper

  def app
    UsersController
  end

  describe 'GET /user/:id/edit' do
    context 'when not authorised'
    context 'when authorised, with invalid user id'
    context 'when authorised, with valid user id'
    context 'when user'
  end

  describe 'PATCH /user/:id/edit' do
    context 'when not authorised'
    context 'when authorised'
    context 'when authorised, with invalid user id, and valid users parameters'
    context 'when authorised, with valid user id, and invalid users parameters'
    context 'when authorised, with valid user id, and valid users parameters'
    context 'when user'
  end
end
