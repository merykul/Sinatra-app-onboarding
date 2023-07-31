require 'rubygems'
require 'bundler'
Bundler.require

# Database setup
require_relative './config/database.yml'

# Session secret
require_relative '.env'

# Controllers
require './app'

# Models
require_relative './models/records'
require_relative './models/city'
require_relative './models/user.rb'

run './app'
