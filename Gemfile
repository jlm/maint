source 'https://rubygems.org'


gem 'rails', '>= 5.2.4.6'
gem 'bundler', '~> 2.0'
gem 'bootsnap',  '>= 1.1.0'

# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.4.0'
gem 'sassc-rails'
gem 'simple_form'
# Use jquery as the JavaScript library
gem 'jquery-rails', '>= 4.4.0'
gem 'will_paginate-bootstrap'

# Sprockets isn't used by the app but is installed by rails as a dependency.
# Versions >= 4 cause issues if app/assets/config/manifest.js is not present.
# This pins sprockets to an earlier version to prevent those errors
gem 'sprockets', '< 4'

# Be able to convert URLs to links.
gem 'rinku'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'json', '>= 2.3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem 'multi_json'
gem 'yajl-ruby'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc'

# store secrets in a .env file at the root level
gem 'dotenv-rails'

# Let's try RailsAdmin
gem 'rails_admin'
gem 'devise', ">= 4.6.0"
gem 'cancancan'
gem 'rails_admin_import', '~> 2.1'

gem 'nokogiri', '~> 1.13'
gem 'rubyXL', '~> 3.4.0'
gem 'postmark-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

group :development, :docker do
	# Use Puma as the app server
	gem 'puma', '>= 4.3.2'
	gem 'dalli'
  gem 'listen'
end

group :development do
  gem 'debase'
  gem 'ruby-debug-ide'
  gem 'rails-erd'
end

group :production do
	gem 'passenger'

	# Use Capistrano for deployment
	gem 'capistrano', '~> 3.4.0'
	gem 'capistrano-rails'
	gem 'capistrano-rbenv'
	gem 'capistrano-passenger'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  #gem 'byebug'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'apparition'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails'
  gem 'bundler-audit'
  gem 'brakeman'

  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
