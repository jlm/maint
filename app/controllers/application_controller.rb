class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	class SyntaxError < StandardError
	end

    rescue_from SyntaxError, with: :syntax_error

    rescue_from CanCan::AccessDenied do |exception|
    	redirect_to main_app.home_url, :alert => exception.message
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
