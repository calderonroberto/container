#!/bin/sh
 
#put all our needed gems in vendors :) 
bundle install --path vendor/bundle

#remove previous assets
rm -R /var/www/container/public/assets
 
# precompile assets (if you need to debug delete all in /public/assets)
rake assets:precompile --trace RAILS_ENV=production

#change permissions
chown -R www-data:www-data /var/www/container/

#reset server
/etc/init.d/apache2 restart
