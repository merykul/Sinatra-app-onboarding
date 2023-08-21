require_relative '../helpers/spec_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require_relative '../../app/controllers/users_controller'

RSpec.describe '[Users API, deletion with records]' do
  include AuthHelper
  include LoggerHelper

  def app
    UsersController
  end

  describe 'DELETE user/:id/delete/with_records' do
    context 'when not authorised'
    context 'when authorised, with invalid user id'
    context 'when authorised, with valid user id'
  end
end
