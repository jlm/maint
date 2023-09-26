# From: http://www.jetthoughts.com/blog/tech/2014/08/27/5-steps-to-add-remote-modals-to-your-rails-app.html
class ModalResponder < ActionController::Responder
  cattr_accessor :modal_layout
  self.modal_layout = "modal"

  def render(*args)
    options = args.extract_options!
    if request.xhr?
      options[:layout] = modal_layout
    end
    controller.render(*args, options)
  end

  def default_render(*args)
    render(*args)
  end

  # It appears that responders-3.1 changes the parameters for redirect_to, somehow.
  def redirect_to(thing_array, status_hash)
    if request.xhr?
      head :ok, location: controller.url_for(thing_array.first)
    else
      controller.redirect_to(thing_array.first, status_hash)
    end
  end
end
