## Commented this out as we are now using connection to same stream (see spec_helper)

#DatabaseCleaner.strategy = :truncation

#RSpec.configure do |config|
#  config.use_transactional_fixtures = false
#  config.before :each do
#    DatabaseCleaner.start
#  end
#  config.after :each do
#    DatabaseCleaner.clean
#  end
#end
