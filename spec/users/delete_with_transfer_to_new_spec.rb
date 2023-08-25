# frozen_string_literal: true
require_relative '../helpers/spec_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/logs_helper'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require 'yaml'

data = YAML.load_file('data.yml')

RSpec.describe '[Users API]' do
  include AuthHelper
  include LoggerHelper

  def app
    Rack::Builder.new do
      run ApplicationController
      use RecordsController
      use SessionsController
      use UsersController
    end.to_app
  end

  describe 'GET user/:id/delete/with_records_transfer_to_new' do
    context 'when not authorised'
    context 'when authorised, with invalid user id'
    context 'when authorised, with valid user id'
    context 'when user'
  end

  describe 'POST user/:id/delete/with_records_transfer_to_new' do
    context 'when not authorised'
    context 'when authorised, with invalid user id, and valid new user parameters'
    context 'when authorised, with valid user id, and invalid new user parameters'
    context 'when authorised, with valid user id, and valid new user parameters'
    context 'when user'
  end
end
