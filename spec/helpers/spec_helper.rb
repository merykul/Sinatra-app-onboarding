# Controllers
require_relative '../../app/controllers/application_controller'
require_relative '../../app/controllers/sessions_controller'
require_relative '../../app/controllers/records_controller'
require_relative '../../app/controllers/users_controller'

# Helpers
require_relative 'auth_helper'

require 'factory_bot'
require_relative '../factories/users'
require_relative '../factories/records'

# require_relative '../../db/seeds'

Bundler.require(:default) # load all the default gems
Bundler.require(Sinatra::Base.environment) # load all the environment specific gems

require 'active_support/deprecation'
require 'active_support/all'
require 'rack/test'
require 'rspec-html-matchers'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include AuthHelper
  config.include Rack::Test::Methods
  config.include RSpecHtmlMatchers
  config.include RSpec::Core::SharedExampleGroup
end

def app
  Rack::Builder.new do
    run ApplicationController
    use RecordsController
    use SessionsController
    use UsersController
  end.to_app
end
