source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem 'jquery-rails', '2.1.1'


# bootstrap gem lacks mobile support.
# but complementing for will_paginate:
gem 'bootstrap-will_paginate', '0.0.7'

gem 'will_paginate', '3.0.3'
gem 'bcrypt-ruby', '3.0.1'


#testing faye
gem 'faye', '0.8.3'
gem 'thin', '1.4.1'

#resque workers
gem 'resque','1.22.0', :require => 'resque/server'

#foreman export, use with: "bundle exec foreman export initscript /etc/init.d"
#gem 'foreman-export-initscript', :git => 'git://github.com/lzgo/foreman-export-initscript.git'
gem 'foreman', '0.62.0'

#to deploy in heroku
gem 'pg', '0.14.1'

#testing fileuploads with s3w
gem 'paperclip', '3.4.1'
gem 'aws-sdk', '1.8.5'
gem 'fog', '1.10.1'


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
  gem 'mysql', '2.8.1'
  #gem 'mysql2', '0.3.11'
end

group :development, :test do
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails','2.10.0'
end

