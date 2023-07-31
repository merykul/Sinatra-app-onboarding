require 'rubygems'
require 'bundler'
Bundler.require

# Database setup
require 'yaml'
database_config = YAML.safe_load(File.read(File.join(File.dirname(__FILE__), 'config', 'database.yml')))
# Now database_config holds the database configuration from database.yml

# Load env variables from .env
require 'dotenv/load'

# Controllers
require_relative './app/controllers/application_controller'
require_relative './app/controllers/records_controller'
require_relative './app/controllers/sessions_controller'

# Models
require_relative 'app/models/records'
require_relative 'app/models/city'
require_relative 'app/models/user'

run ApplicationController
use RecordsController
use SessionsController
