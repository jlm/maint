require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Maint
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Environment
    ENV["SCRIPT_NAME"] ||= ""

    # Postmark
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { :api_key => ENV['POSTMARK_API_KEY'] }

    config.autoload_paths += %W(#{config.root}/app/models/people)

    # this is for timeline_json, from https://stackoverflow.com/questions/27379432/prevent-rails-from-encoding-the-ampersands-in-a-url-when-outputting-json
    config.active_support.escape_html_entities_in_json = false

    MultiJson.use :yajl
    MultiJson.dump_options = { pretty: true }
  end
end

# The change_contents method uses raw strings, not shared strings.
# Therefore it is better not to overwrite the contents of a cell unless it has changed.
# In this application, it's quite likely that the value being written will be the same as the one already there.
module RubyXL::CellConvenienceMethods
    def chg_cell(data, formula_expression = nil)
        unless formula_expression.nil? and self.value == data
            data = change_contents(data, formula_expression)
        end
        data
    end
end

module RubyXL::WorksheetConvenienceMethods
    def add_or_chg(row, col, data, formula_expression = nil)
        if self[row].nil? or self[row][col].nil?
            self.add_cell(row, col, data, formula_expression)
        else
            self[row][col].chg_cell(data, formula_expression)
        end
    end
end
