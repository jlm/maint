Introduction
============

This is a trivial Ruby on Rails application set up to deploy to a server using Capistrano.
The interesting bits really are the Gemfile, the Capfile, the config/deploy.rb and config/deploy/* scripts and the 
lib/capistrano/tasks/* scripts.

For instructions and background, see https://gorails.com/deploy/ubuntu/14.04 and 
http://capistranorb.com/.

The main setup stages were:
$ rails _4.2.3_ new maint -d postgresql
Merge in changes to Gemfile (adding Capistrano, therubyracer, correcting Rails version if necessary)
$ git init
Make sure .gitignore contains the important files config/database.yml and config/secrets.yml
$ git add -A
$ git status
$ git commit -m "Initialize repository"
$ git remote add origin git@github.com:jlm/maint.git
$ git push origin master
Approximately...

$ cap production deploy
This step is quite messy, as /var/www/maint has to exist on the deployment server and it doesn't and needs creating with the right permissions (it tries to
create it but the /var/www directory which it doesn't own).  Then, some special files don't exist and have to be created:
* ~deploy/maint-secrets/database.yml
* ~deploy/maint-secrets/secrets.yml
These have to be linked to the right places in the deployment structure:
* ln -s /home/deploy/maint-secrets/database.yml /var/www/maint/shared/config/
* ln -s /home/deploy/maint-secrets/secrets.yml /var/www/maint/shared/config/
$ createdb maint_production
Apparently that step isn't automated.
