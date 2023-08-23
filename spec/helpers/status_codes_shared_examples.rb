require_relative '../helpers/spec_helper'
require 'yaml'
data = YAML.load_file('data.yml')

RSpec.shared_examples 'not authorised' do

  let(:not_authorised_error) { data['not-authorised-error'] }

  it 'verifies that response status code is 401' do
    expect(last_response.status).to eq 401
  end

  it 'user is on "Not authorised" error page' do
    expect(last_response.body).to include(not_authorised_error)
  end
end

RSpec.shared_examples 'authorised get request' do |endpoint|

  it 'verifies that response code is 200 OK' do
    get endpoint
    expect(last_response.status).to eq 200
  end

  it 'user is redirected to requested page' do
    expect(last_response.body).to include(title)
  end
end
