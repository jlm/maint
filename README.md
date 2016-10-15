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
    $ exec -l $SHELL
```
Then enter "type rbenv" to verify that rbenv is a function.
Then install Ruby:
```
    $ sudo apt-get install libreadline-dev libssl-dev zlib1g-dev
    $ rbenv install 2.2.2
    $ rbenv global 2.2.2
```
However, with Ubuntu 14.04, due to problems with Readline, I found I had to use this incantation to install Ruby:
```
    $ RUBY_CONFIGURE_OPTS=--with-readline-dir="/usr/include/readline" rbenv install 2.2.2
```
Other prerequisites
===================
Install the bundler gem and other prerequisites:
```
    $ gem install bundler
    $ sudo apt-get install postgresql postgresql-client libpq-dev git
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
Create .env, config/database.yml, config/secrets.yml based on the examples in the repository named "example-...".  The title of the site
is configured using the COMMITTEE environment variable in the .env file

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
    $ rails server
```
Click on "sign up".  Follow the instructions.  For this to work, your development machine has to have a way to send emails, and the "devise"
gem has to be able to use it.  This is configured in config/environments/development.rb (see the config.action_mailer.delivery_method entry).
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

The first real step is to import an existing maintenance database spreadsheet using the Import menu.  Then use the Items menu to look at the
maintenance database entries.

Preparing the Import file
=========================
Importing Excel files into other environments can be a tricky business, because the variety of things that can be in an Excel file
is vast.  Some files will not import without preparatory clean-up.  I have come across two classes of problems: hyperlinks on the
Master and Minutes tabs (which should no longer present a problem) and illegal characters in Document Properties.  For the latter,
save a copy of the spreadsheet in Excel and then do File->Info->Inspect Workbook->Document Properties and Personal Information (just
that category).  Click "Remove", then save the copy and import it into the app.


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

Deploying with Docker Cloud
===========================
Another way of deploying the application is using Docker, managed with a service such as [Docker Cloud](https://cloud.docker.com).  Once debugged, this provides a very convenient deployment environment.  My setup for this involved [providing my own node](https://docs.docker.com/docker-cloud/infrastructure/byoh/) to the Docker Cloud service.
```
    $ docker-compose build
    $ docker tag -f maint_web:latest yourusername/maint_web:latest
    $ docker push yourusername/maint_web:latest
```

Then navigate to the "Stacks" tab in Docker Cloud, and select "Create Stack" and upload example-docker-cloud-stack.yml".  Edit as appropriate.  Then "Deploy" it!