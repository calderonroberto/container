# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end



## following lines to allow seleminum access to db for login. Requires transactional_fixtures=true
## http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
class ActiveRecord::Base
  mattr_accessor :shared_connection

  @@shared_connection = nil
  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

#The next block is to test Omniauth(facebook) but it might not be needed
module IntegrationSpecHelper
  def login_with_oauth(service = :facebook)
    visit "/auth/#{service}"
  end
end
RSpec.configure do |config|
  config.include IntegrationSpecHelper, :type => :request
end

## GET FUll Backgraces for RSPEC
#RSpec.configure do |config|
#  # RSpec automatically cleans stuff out of backtraces;
#  # sometimes this is annoying when trying to debug something e.g. a gem
#  config.backtrace_clean_patterns = [
#  ]
#end


