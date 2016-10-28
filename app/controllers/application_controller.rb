class ApplicationController < ActionController::Base
	# Workaround for CanCan from https://github.com/ryanb/cancan/issues/835#issuecomment-18663815
	before_filter do
		resource = controller_name.singularize.to_sym
		method = "#{resource}_params"
		params[resource] &&= send(method) if respond_to?(method, true)
	end

	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	# For APIs, I followed advice here: http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection.html#M000491
	# protect_from_forgery with: :exception unless: -> { request.format.json? }
	protect_from_forgery unless: -> { request.format.json? }

	class SyntaxError < StandardError
	end

    rescue_from SyntaxError, with: :syntax_error

    rescue_from CanCan::AccessDenied do |exception|
    	redirect_to main_app.home_url, :alert => exception.message
	end

	# From: http://www.jetthoughts.com/blog/tech/2014/08/27/5-steps-to-add-remote-modals-to-your-rails-app.html
	def respond_modal_with(*args, &blk)
		options = args.extract_options!
		options[:responder] = ModalResponder
		respond_with *args, options, &blk
	end

  protected

	def syntax_error(exception)
		flash[:warning] = "Syntax error in imported file: #{exception.message}"
		Rails.logger.error "Exception: #{exception.message}, #{current_user.email}, #{request.remote_ip}"
		redirect_to edit_import_path
	end

	def after_sign_in_path_for(resource)
		# return the path based on resource
		root_path + "home"
	end

	def after_sign_out_path_for(resource)
		# return the path based on resource
		root_path + "home"
	end
end
