# You will need ruby 1.9.3p0 and rails 3.2.8
source 'https://rubygems.org'

# Upgradding from:
#ruby "1.9.3"
#gem 'rails', '3.2.6'

ruby "2.2.0"
gem 'rails', '4.2.0'

#jquery
gem 'jquery-rails'

# bootstrap gem lacks mobile support.
# but complementing for will_paginate:
gem 'bootstrap-will_paginate'

gem 'will_paginate'
gem 'bcrypt-ruby'

gem 'faker'

gem 'faye'
gem 'thin'

#resque workers
gem 'resque','1.22.0', :require => 'resque/server'

#foreman export, use with: "sudo bundle exec foreman export initscript /etc/init.d -u root -a icd"
# then, to add: http://www.debian-administration.org/article/28/Making_scripts_run_at_boot_time_with_Debian
gem 'foreman-export-initscript'
gem 'foreman'

#to deploy in heroku
gem 'pg'

#fileuploads with s3w
gem 'paperclip'
gem 'aws-sdk'
gem 'fog'

#For Facebook signin
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'oauth2'

#Facebook data (friends
gem 'koala'

#To make POST requests
gem 'faraday'

#To allow profanity filter
gem 'obscenity'

# Gems used only for assets and not required
# in production environments by default.
#RVCA: rails4 does not use group assets
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
#  gem 'database_cleaner', '0.8.0' #works if transactional_fixtures=false
end

group :production do
  gem 'mysql2'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
end

