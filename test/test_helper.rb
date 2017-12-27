ENV['RAILS_ENV'] ||= 'test'
# require 'database_cleaner'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # DatabaseCleaner.strategy = :truncation
  # DatabaseCleaner.logger = Rails.logger
  # setup { DatabaseCleaner.start }
  # teardown { DatabaseCleaner.clean }


  # Add more helper methods to be used by all tests here...
end
