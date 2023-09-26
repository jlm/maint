# frozen_string_literal: true

source "https://rubygems.org"

gem "bootsnap", ">= 1.1.0"
gem "bundler", "~> 2.0"
gem "rails", ">= 5.2.4.6", "< 6.0"

# Use postgresql as the database for Active Record
gem "pg"
# Use SCSS for stylesheets
gem "bootstrap-sass", "~> 3.4.0"
gem "sassc-rails"
gem "simple_form"
# Use jquery as the JavaScript library
gem "jquery-rails", ">= 4.4.0"
gem "will_paginate-bootstrap"

# Sprockets isn't used by the app but is installed by rails as a dependency.
# Versions >= 4 cause issues if app/assets/config/manifest.js is not present.
# This pins sprockets to an earlier version to prevent those errors
gem "sprockets", "< 4"

# Be able to convert URLs to links.
gem "rinku"

# Use Uglifier as compressor for JavaScript assets
gem "uglifier", "~> 4"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4"
# See https://github.com/rails/execjs#readme for more supported runtimes
gem "execjs"
# gem 'therubyracer', platforms: :ruby     # This gem is no longer supported.
# gem 'mini_racer'    # mini_racer 0.6.2 won't compile on the GitHub Runner at the moment because of a bug.
# Instead of specifying an execution environment for execjs, just install node.js externally in the deployment.

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "json", ">= 2.3.0"
gem "turbolinks"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"
gem "multi_json"
gem "yajl-ruby"
# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc"

# store secrets in a .env file at the root level
gem "dotenv-rails"

# Let's try RailsAdmin
gem "cancancan"
gem "devise", ">= 4.6.0"
gem "rails_admin"
gem "rails_admin_import", "~> 2.1"

gem "nokogiri", "~> 1.14"
gem "postmark-rails"
gem "rubyXL", "~> 3.4.0"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

group :development, :docker do
  gem "dalli"
  gem "listen"
end

group :development do
  gem "rails-erd"
end

group :production do
  gem "passenger"

  # Use Capistrano for deployment
  gem "capistrano", "~> 3.4.0"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rbenv"
end

group :development, :test, :dockertest do
  gem "apparition"
  gem "brakeman"
  gem "bundler-audit"
  gem "capybara"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-rescue"
  gem "pry-stack_explorer"
  # Use Puma as the app server
  gem "puma", ">= 4.3.2"
  gem "rspec-rails"
  gem "rubocop", "~> 1.23"
  gem "selenium-webdriver"
  gem "solargraph", "~> 0.44"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "standard"
end
