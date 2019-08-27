source 'https://rubygems.org'


gem 'rails', '~> 4.2.11'
# Rails 4 is basically deprecated. Below are some dependency updates to fix vulnerabilities.  These would not normally
# be listed in the Gemfile at all.
gem 'rails-html-sanitizer', '~> 1.0.4'
gem "rack", ">= 1.6.11"

# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.4.0'
gem 'sass-rails', '~> 5.0'
gem 'will_paginate-bootstrap'

# Be able to convert URLs to links.
gem 'rinku'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem 'multi_json'
gem 'yajl-ruby'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# store secrets in a .env file at the root level
gem 'dotenv-rails'

# Let's try RailsAdmin
gem 'rails_admin', '~> 1.3'
gem 'devise', ">= 4.6.0"
gem 'cancan'
gem 'rails_admin_import', '~> 2.1'

gem 'simple_form'
gem 'nokogiri', '>= 1.10.4'
gem 'rubyXL', '~> 3.3.29'
gem 'postmark-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

group :development, :docker do
	# Use Puma as the app server
	gem 'puma'
	gem 'dalli'
end

group :production do
	gem 'passenger'

	# Use Capistrano for deployment
	gem 'capistrano', '~> 3.4.0'
	gem 'capistrano-rails'
	gem 'capistrano-rbenv'
	gem 'capistrano-passenger'
end

group :development do
	gem 'rails-erd'
end

group :development, :test do
  
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  #gem 'byebug'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'

  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

