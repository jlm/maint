Introduction
============

This is an attempt to convert the 802.1 Maintenance Database into a web application.  The old database
was formed from a single Excel workbook with magic formulae to generate static HTML output.  It was difficult to maintain and keep error-free.

Installing Rbenv and Ruby
=========================
These commands are for Ubuntu.  For other setups see https://github.com/sstephenson/rbenv.
```
    $ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    $ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    $ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
```
Restart the shell and enter "type rbenv" to verify that rbenv is a function.
Then install Ruby:
```
    $ sudo apt-get install libreadline-dev
    $ rbenv install 2.2.2
    $ rbenv global 2.2.2
```
However, due to problems with Readline, I found I had to use this incantation to install Ruby:
```
    $ RUBY_CONFIGURE_OPTS=--with-readline-dir="/usr/include/readline" rbenv install 2.2.2
```
Other prerequisites
===================
Install the bundler gem and other prerequisites:
```
    $ gem install bundler
    $ sudo apt-get install postgresql postgresql-client libpq-dev
    $ sudo apt-get install build-essential
```

Clone the repository and add missing files
==========================================
Clone the source code from GitHub and install the required gems for the development environment:
```
    $ git clone https://github.com/jlm/maint.git
    $ cd maint
    $ bundle install
```
Create .env, config/database.yml, config/secrets.yml based on the examples in the repository named "example-...".  The title of the site
is configured using the COMMITTEE environment variable in the .env file


Deploying with Capistrano
=========================

This Ruby on Rails app is set up to deploy to a server using Capistrano.  For instructions and background, see https://gorails.com/deploy/ubuntu/14.04, 
[also described here](https://www.digitalocean.com/community/tutorials/how-to-automate-ruby-on-rails-application-deployments-using-capistrano), and http://capistranorb.com/.
My setup is based on an Ubuntu virtual machine running Nginx and Passenger.

Create .env, config/database.yml, config/secrets.yml based on the examples in the repository named "example-..."

```
	$ cap production deploy
```
This step is quite messy, as /var/www/maint has to exist on the deployment server and it doesn't and needs creating with the right permissions (it tries to
create it but the /var/www directory which it doesn't own).  Then, some special files don't exist and have to be created:
* ~deploy/maint-secrets/database.yml
* ~deploy/maint-secrets/secrets.yml

These have to be linked to the right places in the deployment structure:
* ln -s /home/deploy/maint-secrets/database.yml /var/www/maint/shared/config/
* ln -s /home/deploy/maint-secrets/secrets.yml /var/www/maint/shared/config/
```
	$ createdb maint_production
```
Apparently that step isn't automated.

The nginx configuration file is not altered automatically to add the new application, so you have to manually edit /opt/nginx/conf/nginx.conf to add a section for the new app,
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
