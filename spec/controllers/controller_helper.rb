require_relative '../rails_helper'

RSpec.configure do |config|

  config.extend  ControllerMacros,                type: :controller
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include OmniauthMacros,                  type: :controller

  config.use_transactional_fixtures = true

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
