# frozen_string_literal: true

# rubocop:disable Style/Documentation

class RegistrationsController < Devise::RegistrationsController
  protected

  # These methods are overridden to allow redirection to a custom path
  def after_sign_up_path_for(_resource)
    "#{root_path}home"
  end

  def after_inactive_sign_up_path_for(_resource)
    "#{root_path}home"
  end
end
# rubocop:enable all
