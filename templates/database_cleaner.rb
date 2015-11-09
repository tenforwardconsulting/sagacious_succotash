RSpec.configure do |config|

  # Since we use database cleaner, have it put us into a transaction instead of rspec.
  config.use_transactional_fixtures = false

  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each, js: true do
    DatabaseCleaner.strategy = :truncation
  end

  config.before :each, driver: :poltergeist do
    DatabaseCleaner.strategy = :truncation
  end

  config.before :each, driver: :poltergeist_debug do
    DatabaseCleaner.strategy = :truncation
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
