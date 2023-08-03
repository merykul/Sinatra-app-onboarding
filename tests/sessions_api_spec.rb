require_relative 'helpers/spec_helper'
require_relative '../app/controllers/sessions_controller'

RSpec.describe 'Sessions API' do
  include AuthHelper
  def app
    SessionsController
  end

  describe 'GET /log_in_form' do
    context 'when logged in' do
      it 'redirects to homepage' do
        clear_cookies # Clear the session
        log_in('TestUser', 'Test123456!')
        get '/log_in_form'
        follow_redirect!
        expect(last_request.path).to eq('/homepage')
        expect(last_response.status).to eq 200
      end
    end

    context 'when not logged in' do
      it 'redirects to login page' do
        get '/log_in_form'
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('Log in')
      end
    end
  end
end
