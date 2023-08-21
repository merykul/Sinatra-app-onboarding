require_relative 'helpers/rs/spec_helper'
require_relative 'helpers/logs_helper'
require_relative '../app/controllers/sessions_controller'
require_relative '../app/controllers/records_controller'

RSpec.describe '[Records API, cities statistics]' do
  include AuthHelper
  include LoggerHelper

  def app
    RecordsController
  end

  describe 'GET /cities_statistics' do
    context 'when not logged in'
    context 'when logged in'
  end
end
