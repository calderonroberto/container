#!/bin/sh
 
#put all our needed gems in vendors :) 
bundle install --path vendor/bundle

#migrate anything new
bundle exec rake db:migrate
bundle exec rake db:migrate RAILS_ENV="production" 


#remove previous assets
rm -R /var/www/container/public/assets/*
 
# precompile assets (if you need to debug delete all in /public/assets)
bundle exec rake assets:precompile --trace RAILS_ENV=production

#change permissions
chown -R www-data:www-data /var/www/container/

#reset server
killall nginx
/etc/init.d/nginx restart

