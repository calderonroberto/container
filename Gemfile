# You will need ruby 1.9.3p0 and rails 3.2.8
source 'https://rubygems.org'

ruby "1.9.3"
gem 'rails', '3.2.6'

#jquery
gem 'jquery-rails', '2.1.1'

# bootstrap gem lacks mobile support.
# but complementing for will_paginate:
gem 'bootstrap-will_paginate', '0.0.7'

gem 'will_paginate', '3.0.3'
gem 'bcrypt-ruby', '3.0.1'

gem 'faker', '1.2.0'

#testing faye
gem 'faye', '0.8.3'
gem 'thin', '1.4.1'

#resque workers
gem 'resque','1.22.0', :require => 'resque/server'

#foreman export, use with: "sudo bundle exec foreman export initscript /etc/init.d -u root -a icd"
# then, to add: http://www.debian-administration.org/article/28/Making_scripts_run_at_boot_time_with_Debian
gem 'foreman-export-initscript #', :git => 'git://github.com/lzgo/foreman-export-initscript.git'
gem 'foreman', '0.62.0'

#to deploy in heroku
gem 'pg', '0.14.1'

#testing fileuploads with s3w
gem 'paperclip', '3.4.1'
gem 'aws-sdk', '1.8.5'
gem 'fog', '1.10.1'

#For Facebook signin
gem 'devise', '3.2.1'
gem 'omniauth', '1.1.4'
gem 'omniauth-facebook', '1.5.0'
gem 'oauth2', '0.8.1'

#Facebook data (friends
gem 'koala', '1.8.0'

#To make POST requests
gem 'faraday', '0.9.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'capybara', '1.1.2' 
  gem 'factory_girl_rails', '1.4.0' 
#  gem 'database_cleaner', '0.8.0' #works if transactional_fixtures=false
end

group :production do
  #gem 'mysql', '2.8.1'
  gem 'mysql2', '0.3.11'
end

group :development, :test do
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails','2.10.0'
end

