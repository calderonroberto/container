faye: bundle exec rackup faye.ru -E production -s thin -p 9292
worker: bundle exec rake RAILS_ENV=production resque:work INTERVAL=0.7 QUEUE=broadcasters_queue
worker: bundle exec rake RAILS_ENV=production resque:work INTERVAL=0.7 QUEUE=facebook_queue
worker: bundle exec rake RAILS_ENV=development resque:work INTERVAL=5.0 QUEUE=checkins_queue VVERBOSE=1
