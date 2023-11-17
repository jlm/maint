# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # For APIs, I followed advice here: http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection.html#M000491
  # protect_from_forgery with: :exception unless: -> { request.format.json? }
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  class SyntaxError < StandardError
  end

  rescue_from SyntaxError, with: :syntax_error

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.warn "Access denied on #{exception.action} #{exception.subject.inspect}"
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  # From: http://www.jetthoughts.com/blog/tech/2014/08/27/5-steps-to-add-remote-modals-to-your-rails-app.html
  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with(*args, options, &blk)
  end

  protected

  def syntax_error(exception)
    flash[:warning] = "Syntax error in imported file: #{exception.message}"
    Rails.logger.error "Exception: #{exception.message}, #{current_user.email}, #{request.remote_ip}"
    redirect_to edit_import_path
  end

end

# rubocop:enable all
