# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Download API]' do
  include AuthHelper
  include LoggerHelper

  def app
    DownloadController
  end

  describe 'GET /exel_file_download' do
    context 'when authorised'
    context 'when not authorised'
  end
end
