#! /bin/bash
#export SECRET_KEY_BASE=$(bundle exec rake secret)
#export DEVISE_PEPPER=$(bundle exec rake secret)
export RAILS_SERVE_STATIC_FILES='true'
if [ -r /myapp/secrets.sh ]
then
  . /myapp/secrets.sh
fi

echo Waiting around
sleep 5
bundle exec rake db:create db:migrate
bundle exec rake assets:precompile
bundle exec rails s Puma -p 3000 -b '0.0.0.0'
