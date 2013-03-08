#!/bin/sh
 
#put all our needed gems in vendors :) 
bundle install --path vendor/bundle

#migrate anything new
rake db:migrate
rake db:migrate RAILS_ENV="production" 

#remove previous assets
rm -R public/assets
 
# precompile assets (if you need to debug delete all in /public/assets)
rake assets:precompile --trace RAILS_ENV=production

#change permissions
chown -R www-data:www-data /var/www/container/

#reset server
killall nginx
/etc/init.d/apache2 restart
