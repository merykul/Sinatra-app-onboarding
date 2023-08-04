require_relative 'helpers/spec_helper'
require_relative '../app/controllers/records_controller'

RSpec.describe 'Records API' do
  include AuthHelper

  def app
    RecordsController
  end

  describe 'POST /create_person' do
    context 'when logged in, and with valid data' do
      it 'saves new record to records table'
      it 'redirects to /people_list page after successful record save'
      it 'response code is 200 OK'
    end

    context 'when logged in, with empty values' do
      it 'error messages are displayed'
    end

    context 'when not authorised, and with valid data' do
      it 'record is not saved to records table'
      it 'user is redirected to /start page'
    end
  end

  describe 'GET /people_list' do
    context 'when not authorised'
    context 'when logged in'
    context 'when city is defined'
  end

  describe 'GET /cities_statistics' do
    context 'when not logged in'
    context 'when logged in'
  end

  describe 'PATCH /records/:id/edit' do
    context 'when not authorised'
    context 'when logged in, with valid data'
    context 'when logged in, with empty parameters'
    context 'when logged in with invalid record id'
  end

  describe 'DELETE /records/:id/delete' do
    context 'when not authorised'
    context 'when logged in with invalid record id'
    context 'when logged in'
  end
end
