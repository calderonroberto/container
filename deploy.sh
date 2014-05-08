#!/bin/sh
chown -R magiclab:magiclab ../
sudo -u magiclab git pull

#put all our needed gems in vendors 
echo building gems
bundle install --path vendor/bundle

#migrate anything new
echo running migrations
bundle exec rake db:migrate RAILS_ENV="production" 
bundle exec rake db:seed RAILS_ENV="production"

#remove previous assets
echo removing previous assets
rm -R /var/www/icd1/container/public/assets/*
 
# precompile assets (if you need to debug delete all in /public/assets)
echo precompiling assets
bundle exec rake assets:precompile --trace RAILS_ENV=production

#change permissions
echo ensuring permissions
chown -R www-data:www-data ../container/

#restart workers
echo killing all previous ruby and icd processes
/etc/init.d/icd stop
killall ruby
sleep 5
echo starting workers
/etc/init.d/icd start

#reset server
echo killing nginx
killall nginx
echo restarting nginx
/etc/init.d/nginx restart

#restart workers
#echo starting workers with foreman -f Procfile
#foreman start -f Procfile &

#echo restarting workers
#cd /var/www/icd
#sh start-workers.sh stop
#sh start-workers.sh start


