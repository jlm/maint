Introduction
============

This is an attempt to convert the 802.1 Maintenance Database into a web application.  The old database was formed from a single Excel workbook with magic
formulae to generate static HTML output.  It was difficult to maintain and keep error-free.


Creating the App and deploying it with Capistrano
=================================================

This Ruby on Rails app is set up to deploy to a server using Capistrano.  For instructions and background, see https://gorails.com/deploy/ubuntu/14.04, 
[also described here](https://www.digitalocean.com/community/tutorials/how-to-automate-ruby-on-rails-application-deployments-using-capistrano), and http://capistranorb.com/.
My setup is based on an Ubuntu virtual machine running Nginx and Passenger.

The interesting bits really are the Gemfile, the Capfile, the config/deploy.rb and config/deploy/* scripts and the 
lib/capistrano/tasks/* scripts.


The main setup stages were:
```
    $ rails _4.2.3_ new maint -d postgresql
```
Merge in changes to Gemfile (adding Capistrano, therubyracer, correcting Rails version if necessary)
```
    $ git init
```
Make sure .gitignore contains the important files config/database.yml and config/secrets.yml
```
    $ git add -A
	$ git status
	$ git commit -m "Initialize repository"
	$ git remote add origin git@github.com:jlm/maint.git
	$ git push origin master
```
Approximately...

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