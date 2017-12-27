ENV['RAILS_ENV'] ||= 'test'
#require 'database_cleaner'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # self.use_transactional_tests = false
  # DatabaseCleaner.clean_with :deletion
  # DatabaseCleaner.strategy = :deletion

  # :truncation
  # :transaction
  # :deletion

  setup do # before each
  #  DatabaseCleaner.start
  #  DatabaseCleaner.clean
  end
  #
  teardown do # before each
    # DatabaseCleaner.start
    # DatabaseCleaner.clean
  end
  # setup { DatabaseCleaner.clean }
  # Add more helper methods to be used by all tests here...
end
