MAGIC "Cherry" container

# Introduction

Ubiquitous Computing, introduced by Weiser during the 1990s predicted a world where invormation and communication technologies would be part of our environment, softening our interaction with other people.

Today, computing forms essential part of our environment and our bodies through embedded computing, situated technology, portable devices and wireless networks. This has made the paradigm of Ubiquitous Computing a tangible reality.

Displays are one of such types of technologies. They have become pervasive in our environment through situated and large displays, and our bodies through mobile devices. Yet, developing multi-display applications that align with Weiser's vision is a challenging endeavor. There are numerous types of devices, communication protocols, hardware specifications and software development kits that a developer can choose from. 

# Cherry

The MAGIC Container, "Cherry", is a web-based framework for multi-display applications. Cherry is designed to provide ease of development of applications for situated large displays and mobile devices.

# Dependencies

Cherry is written as a Rails 3.* application and depends on Resque and Faye. NOTE: Faye runs on port 9292 by default, and you need to make sure that such port is open to the outside world. 

IMPORTANT: Make sure you have ruby V "1.9.3" and 'rails', '3.2.6'. Using Ruby 2.0.0 will result in a broken pipeline/assets-compilation installation: CSS and JS files will not compile. Until I port the app to Ruby 4, one day, maybe.

# USERS: Deploying at heroku

If you're not familiar with heroku you can find a quick guide here: https://devcenter.heroku.com/articles/quickstart.

The first step is to install the heroku toolbelt (https://toolbelt.heroku.com/) If you're running ubuntu you can simply run the following command:

```
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
```

Log in to Heroku. Depending on your setting, if you have already a ssh key in your system you might need to add the keys to heroku.

```
heroku login
heroku keys:add ~/.ssh/id_rsa.pub
```

Now you can deploy "Cherry" at heroku. From within the project folder create the heroku app, add registogo and deploy the rails app. Don't forget to migrate (this is important, even if you're updating from a previous version).

```
heroku create <pick_a_name>
heroku addons:add redistogo:nano
git push heroku master
heroku run rake --trace db:migrate
```

If anything goes wrong, you can debug your application with the command:

```
heroku logs --tail
```

**IMPORTANT NOTICE: Deploying in Heroku with the current build WILL NOT make use of workers, because we want to keep everything FREE for you. The current build uses javascript and a RESTful api bundled within the container to keep displays updated. If you want a more responsive interface and scalability you should consider installing your own instance using your own server (Installing from the ground-up).**

# DEVELOPERS: Installing from the ground-up.

**IMPORTANT: The following instructions are only pertinent if you are running your own server for development purposes. We STRONGLY recommend that you use Heroku if you're only planning on using the app. Future updates of Cherry will be easier.**

### Open relevant ports

You need to open port 80 and 9292 in your server. If you already have an Apache/Nginx server on port 80 you can follow the instructions below to set up Phusion Passenger.

### Install Ruby, RubyGems and Rails

We assume you'll be running a linux box (Debian/Ubuntu). And you'll first need to install Ruby, Rubygems and Rails. You can follow the instructions here: http://rubyonrails.org/download 

Make sure that you have the following dependencies so that your Ruby installation supports Rails
```
sudo apt-get --no-install-recommends install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev libgdbm-dev ncurses-dev automake libtool bison subversion pkg-config libffi-dev
```

### Install Dependencies


Cherry uses Resque workers to manage background processes. Resque uses Redis (http://redis.io/), so you need to install it with: 

```
sudo apt-get install redis-server
```

We will also need imagemagik to upload images 

```
sudo apt-get install imagemagick
```

### Get the latest version of the Cherry container.

Visit http://github.com/cherrycontainer

If you'll be using phusion passenger make sure to change the permission of the downloaded files to your apache user (in Debian/Ubuntu that would be www-data)

Don't forget to sort out your dependencies:

```
sudo apt-get install libpq-dev libmysqld-dev
````


```
bundle install --path vendor/bundle RAILS_ENV=production
```

And precompile the project assets (if you need to debug the project delete everything in /public/assets)

```
bundle exec rake assets:precompile --trace RAILS_ENV=production
```

Out of the box, Cherry is configured to run on top of Mysql, so you need to configure your username and password on config/database.yml. After doing so, initiate the database with:

```
bundle exec rake db:migrate RAILS_ENV=production
```

You could now run a standalone production container with:

```
bundle exec foreman start -f Procfile_production_standalone
```

However, chances are you are already running other services in port 80, or want a faster http server (apache, nginx). Below you will find instructions on how to marry apache/nginx and the Cherry container.

### Install Phusion Passenger

```
sudo apt-get install libcurl4-openssl-dev
```



We prefer running Cherry with Phusion Passenger. You will find instructions to setting up passenger with either Nginx or Apache here: https://www.phusionpassenger.com/download Follow the instructions to point to the "public" folder of Cherry.




Make sure that the project folder "container" and all it's sub-folders are owned by "www-data":

```
sudo chmod -R www-data:www-data container
```

### Starting Faye and Resque (init.d)

Cherry depends on both Resque (background process management) and Faye (event management). Both run independently of Passenger. You can run (within your container folder): 

```
foreman start -f Procfile_production_passenger
```

Or export to /etc/init.d/ so that it's automatically run everytime your server boots up. To do this you first export your foreman script:

```
sudo gem install foreman-export-initscript
cp Procfile_production_passenger Procfile
bundle exec foreman export initscript /etc/init.d
rm Procfile
```

And make it executable:

```
sudo chmod 755 /etc/init.d/app
```

And tell your system about the changes

```
update-rc.d app defaults
```

### Other Alternatives

If you have a VDMDK file. Virtual Box file you can start up with virtual box like this:

```
VBoxHeadless --startvm RED --vrdp=off
```

If you have access to a GUI you can use virtualbox. In Ubuntu, Download virtualbox

```
sudo apt-get install virtualbox
```

And then run in a console: 

```
virtualbox --startvm RED
```

