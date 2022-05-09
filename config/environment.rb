# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
ENV['HOST_PORT'] ||= ":80"
mylog = Logger.new(STDERR)
mylog.info("environment.rb: The ExecJS runtime is #{ExecJS.runtime.name}")
