[![Tests](https://github.com/jlm/maint/actions/workflows/run-tests.yml/badge.svg)](https://github.com/jlm/maint/actions/workflows/run-tests.yml)
[![Build](https://github.com/jlm/maint/actions/workflows/ci.yml/badge.svg)](https://github.com/jlm/maint/actions/workflows/ci.yml)

Introduction
============

This application is a conversion of the 802.1 Maintenance Database into a web application.  The old database
was formed from a single Excel workbook with magic formulae to generate static HTML output.  It was difficult to maintain
and keep error-free.

To modify the application or run it locally in a development environment, some setup is required.  However if you just
want to run it, you can skip to the "Deploying with Docker Compose" section below.

Installing Rbenv and Ruby
=========================

These commands are for Ubuntu.  For other setups see https://github.com/sstephenson/rbenv.
```
    $ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    $ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    $ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    $ exec -l $SHELL
```
Then enter "type rbenv" to verify that rbenv is a function.
Then install Ruby:
```
    $ sudo apt-get install build-essential libreadline-dev libssl-dev zlib1g-dev
    $ rbenv install 2.7.6
    $ rbenv global 2.7.6
```
Previously, with Ubuntu 14.04 with Ruby 2.2.2 , due to problems with Readline, I found I had to use this incantation to install Ruby:
```
    $ RUBY_CONFIGURE_OPTS=--with-readline-dir="/usr/include/readline" rbenv install 2.2.2
```
Other prerequisites
===================
Install the bundler gem and other prerequisites:
```
    $ gem install bundler
    $ sudo apt-get install postgresql postgresql-client libpq-dev git libicu-dev
```

Clone the repository and add missing files
==========================================
Clone the source code from GitHub and install the required gems for the development environment:
```
    $ git clone https://github.com/jlm/maint.git
    $ cd maint
    $ bundle install
    $ mkdir public/uploads
```
Create `.env`, `config/database.yml`, `config/secrets.yml` based on the examples in the repository named "`example-`...".  The title of the site
is configured using the COMMITTEE environment variable in the `.env` file

Set up Postgresql for the development environment
=================================================
These instructions assume that the name of the Postgres user (called a "role") is "deploy".  Also, that your UN*X username is "deploy".
If those assumptions are invalid, the PostgreSQL setup can be more complicated.  It's much simpler if the UN*X username and the PostgreSQL
role name are the same.
```
    $ sudo su - postgres
    $ psql
    postgres# create role deploy with createdb login password 'somepassword';
    postgres# \q
    $ createdb -O deploy maint_development          # actually this step should not be necessary, as rake db:setup does it.
    $ exit

    $ rake db:setup
```

Try it out
==========
At this point you should be able to start the server and connect to it using your web browser at http://localhost:3000/users/sign_in.
```
    $ rbenv rehash
    $ rails server
```
Click on "sign up".  Follow the instructions.  For this to work, your development machine has to have a way to send emails, and the "devise"
gem has to be able to use it.  This is configured in `config/environments/development.rb` (see the `config.action_mailer.delivery_method` entry).
If you don't have this set up, you can find the link for the sign-up configuration in the debug output in the terminal window,
and enter it directly into the browser.  Then, log in to the application using your new username and password.

Here's the hacky bit: the app has no way to create an administrator user, so you have to hack this manually.  After creating your user and
logging in, stop the server and do the following, substituting the newly created user's email address:
```
    $ rails console
    irb(main):001:0> u = User.where(email: "user@example.com").first
    ...
    irb(main):001:0> u.admin=true
    => true
    irb(main):002:0> u.save
    ...
    => true
    irb(main):003:0> quit
    $ rails server
```
Now, when logging in to the app or refreshing the page, you should see Administrator options in the top header.

When migrating from the Excel-based maintenance process, the first real step is to import an existing maintenance
database spreadsheet using the Import menu.  Then use the Items menu to look at the maintenance database entries.

Preparing the Import file
=========================
Importing Excel files into other environments can be a tricky business, because the variety of things that can be in an Excel file
is vast.  Some files will not import without preparatory clean-up.  I have come across two classes of problems: hyperlinks on the
Master and Minutes tabs (which should no longer present a problem) and illegal characters in Document Properties.  For the latter,
save a copy of the spreadsheet in Excel and then do File->Info->Inspect Workbook->Document Properties and Personal Information (just
that category).  Click "Remove", then save the copy and import it into the app.


Creating a Dockerized version of the app
========================================
On the development machine:
```
    $ docker-compose build
    $ docker tag maint_web:latest yourusername/maint_web:latest
    $ docker push yourusername/maint_web:latest
```


Deploying with Docker Compose
=============================
The preferred method of deploying the application is using Docker Compose.  This assumes you have a separate Docker
hosting environment.  I use an Ubuntu virtual machine for this, with Docker CE installed. Digital Ocean offers a
[pre-configured setup](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-docker-application)
for this. 

On the Docker host (target), first prepare the storage area for the database (there are lots of other, perhaps better
ways to do this, including using a persistent docker volume):
```bash
    $ sudo mkdir -p /srv/docker/postgresql/data
    $ sudo chmod -R go-rwx /srv
    $ sudo chown 999.root /srv/docker/postgresql/data
```
Then copy `example-deploy-docker-compose.yml` to `deploy-docker-compose.yml` and edit it to configure the application.
The `POSTGRES_USER` and `POSTGRES_PASSWORD` fields can be set arbitrarily (but must be the same for the db and web
sections). The `SECRET_KEY_BASE` and `DEVISE_PEPPER` entries are Rails secret keys, and can be generated using `openssl
rand -hex 64` or `rake secret` (if you happened to have Rake installed).  The `VIRTUAL_HOST` and `LETSENCRYPT*` entries
are only required if you are using Jason Wilder's `nginx-proxy` and Yves Blusseau's `docker-letsencrypt-nginx-proxy-companion`
(see section below).  The remaining fields configure aspects of the user interface that depend on the use you are
putting this project to.

Once the Docker Compose file has been customised, the application can be launched with the
command

```
    $ docker-compose -f deploy-docker-compose.yml up
```
It takes a couple of minutes to initialise, set up the database and write cache files.  Test it by navigating to
`localhost:80`.  To terminate, press Control-C.  To launch it in the background, use

```bash
    $ docker-compose -f deploy-docker-compose.yml up -d
```  

Enhancing the Docker Compose method to add HTTPS and a proxy server
===================================================================
Jason Wilder has written a very fine [reverse proxy for Docker containers](https://github.com/nginx-proxy/nginx-proxy)
based on Nginx.  Yves Blusseau has written an excellent [companion utility](https://github.com/nginx-proxy/acme-companion)
which automatically generates, applies (and renews) [Let's Encrypt](https://www.letsencrypt.org) certificates to each virtual
host created by the above.  No account or additional setup is needed.

With a few simple steps, this allows multiple Dockerized web applications to run on the same VM, each as different
virtual hosts, secured by valid certificates and supporting HTTPS without the web application having to be HTTPS-aware.
Adding a new application requires no configuration beyond including the `VIRTUAL_HOST`, `LETSENCRYPT_HOST` and
`LETSENCRYPT_EMAIL` environment variables to the environment of the new container.

To apply this to the `maint` application, first register the newly invented DNS name of the web application virtual
host to be a CNAME of the Docker host.  Then, before starting the web application with Docker Compose as described
in the previous section, run these commands:
 
```
      $ sudo mkdir /web/nginx-proxy
      $ sudo chown YOU /web/nginx-proxy
      $ sudo docker network create nginx-proxy
      
      $ sudo docker run -d -p 80:80 -p 443:443 --name nginx-proxy --net nginx-proxy --restart=always -v /web/nginx-proxy:/etc/nginx/certs:ro  -v /etc/nginx/vhost.d     -v /usr/share/nginx/html -v /var/run/docker.sock:/tmp/docker.sock:ro  nginxproxy/nginx-proxy
      $ sudo docker run -d --name nginx-letsencrypt --net nginx-proxy --restart=always -v /web/nginx-proxy:/etc/nginx/certs:rw -v /var/run/docker.sock:/var/run/docker.sock:ro -v acme:/etc/acme.sh --volumes-from nginx-proxy nginxproxy/acme-companion
```

Deploying with Capistrano
=========================

**NOTE: The Capistrano deployment process hasn't been used for many years, and would probably require updates to work.**

This Ruby on Rails app was set up to deploy to a server using Capistrano.  For instructions and background, see https://gorails.com/deploy/ubuntu/14.04,
[also described here](https://www.digitalocean.com/community/tutorials/how-to-automate-ruby-on-rails-application-deployments-using-capistrano), and http://capistranorb.com/.
My setup is based on an Ubuntu virtual machine running Nginx and Passenger.
(However, it may be better to use Docker, as described above.)

Create `.env`, `config/database.yml`, `config/secrets.yml` based on the examples in the repository named "`example-`..."

```
	$ cap production deploy
```
This step is quite messy, as /var/www/maint has to exist on the deployment server and it doesn't and needs creating with the right permissions (it tries to
create it but the /var/www directory which it doesn't own).  Then, some special files don't exist and have to be created:
* `~deploy/maint-secrets/database.yml`
* `~deploy/maint-secrets/secrets.yml`

These have to be linked to the right places in the deployment structure:
```
	$ ln -s /home/deploy/maint-secrets/database.yml /var/www/maint/shared/config/
	$ ln -s /home/deploy/maint-secrets/secrets.yml /var/www/maint/shared/config/
```

```
	$ createdb maint_production
```
Apparently that step isn't automated.

The nginx configuration file is not altered automatically to add the new application, so you have to manually edit `/opt/nginx/conf/nginx.conf` to add a section for the new app,
in the existing `server` section after the `root` line.
Mine looked like this:
```
        location ~ ^/maint(/.|$) {
                alias /var/www/maint/current/public$1;
                passenger_base_uri /maint;
                passenger_app_root /var/www/maint/current;
                passenger_document_root /var/www/maint/current/public;
                passenger_enabled on;
        }
```
