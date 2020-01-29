Rails.application.configure do
  ENV["SECRET_KEY_BASE"] = "929fd75ab3012484860232342af77e888fee9bbb042735394249355d7888d1ac858c760cfc02c6f2d058df7293944d2ba888860fa6910d72503be72ce920b8c29293590943025884733232342af77e888fee9bbb042735394249355d7888d1ac858c760cfc02c6f2d058df7293944d2ba888860fa6910d72503be72ce920b8c29293590943025884733232342af77e888fee9bbb042735394249355d7888d1ac858c760cfc02c6f2d058df7293944d2ba888860fa6910d72503be72ce920b8c2"
  ENV["DEVISE_PEPPER"] = "d23a123dd291c853d872cb4443ec1fd75ab3960d7cb23563bc07cb85f8084151e943718db34c8befca712516f1118b3bd09d8872707039901e5d39a8127b01f6d23a123dd291c853d872cb4443ec19430258847332b23563bc07cb85f8084151e943718db34c8befca712516f1118b3bd09d8872707039901e5d39a8127b01f6d23a123dd291c853d872cb4443ec19430258847332b23563bc07cb85f8084151e943718db34c8befca712516f1118b3bd09d8872707039901e5d39a8127b01f6"
  ENV["RAILS_SERVE_STATIC_FILES"] = "yes"
  ENV["COMMITTEE"] = "802.4"
  ENV["REQ_URL"] = "http://www.ieee802.org/n/files/public/maint/requests/maint_%s.pdf"
  ENV["MAIL_SENDER"] = "admin@802-1.org"
  ENV["SERVER_PRODUCTION"] = "www.802-1.org"
  ENV["SERVER_STAGING"] = "www.802-1.org"
  ENV["SERVER_DEVELOPMENT"] = "www.802-1.org"

  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.importing = false
end
