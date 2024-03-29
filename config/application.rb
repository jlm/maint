require File.expand_path("../boot", __FILE__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Maint
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Environment
    ENV["SCRIPT_NAME"] ||= ""

    # Postmark
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = {api_key: ENV["POSTMARK_API_KEY"]}

    config.autoload_paths += %W[#{config.root}/app/models/people]

    # Per-form CSRF Tokens were added in Rails 5
    config.action_controller.per_form_csrf_tokens = true

    config.middleware.use ActionDispatch::Session::CookieStore, {key: "_maint_session", cookie_only: true}

    # This will be required in Rails 7 as I understand it, for Hotwire/Turbo.
    # config.responders.error_status = :unprocessable_entity
    # config.responders.redirect_status = :see_other

    # Support for TimelineJS has been suspended because Brakeman doesn't like the security laxity
    if false
      # This is for timeline_json, from https://stackoverflow.com/questions/27379432/prevent-rails-from-encoding-the-ampersands-in-a-url-when-outputting-json
      config.active_support.escape_html_entities_in_json = false

      # This unnecessary configuration was part of debugging why JSON responses weren't working with TimelineJS Wordpress plugin
      MultiJson.use :yajl
      MultiJson.dump_options = {pretty: true}

      # Reduce XSS support to get TimelineJS to work with this site.
      config.action_dispatch.default_headers.merge!("Access-Control-Allow-Origin" => "*")
    end
  end
end

# The change_contents method uses raw strings, not shared strings.
# Therefore it is better not to overwrite the contents of a cell unless it has changed.
# In this application, it's quite likely that the value being written will be the same as the one already there.
module RubyXL::CellConvenienceMethods
  def chg_cell(data, formula_expression = nil)
    unless formula_expression.nil? && (value == data)
      data = change_contents(data, formula_expression)
    end
    data
  end
end

module RubyXL::WorksheetConvenienceMethods
  def add_or_chg(row, col, data, formula_expression = nil)
    if self[row].nil? || self[row][col].nil?
      add_cell(row, col, data, formula_expression)
    else
      self[row][col].chg_cell(data, formula_expression)
    end
  end
end
