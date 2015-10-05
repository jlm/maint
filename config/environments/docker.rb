# The Docker environment is a clone of the production one, with a few changes.
require_relative 'production'
Rails.application.configure do
  config.cache_store = :dalli_store, ENV['MEMCACHED_SERVICE_HOST'], { namespace: 'maint' }
end
