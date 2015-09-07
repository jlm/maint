Creating the App and deploying it with Capistrano
=================================================

Note: this section is mostly of interest only to people writing their own Ruby on Rails application for deployment
with Capistrano.  These steps are not necessary (and would interfere with) just using or modifying the "maint" app.

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
