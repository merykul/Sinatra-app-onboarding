require 'rubygems'
require 'bundler'
Bundler.require

# Database setup
require_relative './config/database.yml'

# Session secret
require_relative '.env'

# Controllers
require_relative './app/controllers/records_controller'
require_relative './app/controllers/sessions_controller'
require_relative './app/controllers/application_controller'

# Models
require_relative './models/records'
require_relative './models/city'
require_relative './models/user.rb'

run ApplicationController
use RecordsController
use SessionsController
