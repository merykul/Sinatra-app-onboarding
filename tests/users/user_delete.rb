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

  describe 'GET /user/:id/delete'do
    context 'when not authorised'
    context 'when authorised'
    context 'when user'
    context 'when authorised, with invalid user id'
  end
end
