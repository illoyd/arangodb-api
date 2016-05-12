require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

# Include Rspec and related
require 'rspec'
require 'rspec/its'
require 'climate_control'
require 'faker'

# Configure RSpec
RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'arangodb/api'

# Require all helpers
Dir.glob('./spec/spec_support/**.rb').each { |file| require file }

# Configure ArangoDB connection URI
ENV['ARANGODB_URI'] ||= 'arangodb://localhost/arangodb_api_test'
