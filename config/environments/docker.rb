# The Docker environment is a clone of the production one, with a few changes.
require_relative 'production'
Rails.application.configure do
  #config.cache_store = :dalli_store, ENV['MEMCACHED_SERVICE_HOST'], { namespace: 'maint' }
  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX
end
