# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Records API]' do
  include AuthHelper
  include LoggerHelper

  def app
    RecordsController
  end

  describe 'GET /records/:id/edit' do
    context 'when not authorised'
    context 'when authorised'
    context 'when logged in with invalid record id'
  end

  describe 'PATCH /records/:id/edit' do
    context 'when not authorised'
    context 'when logged in, with valid data'
    context 'when logged in, with empty parameters'
    context 'when logged in with invalid record id'
  end
end
