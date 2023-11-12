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

  # It appears that responders-3.1 changes the parameters for redirect_to, somehow.  This is an awful hack.
  def redirect_to(thing, status_hash)
    if request.xhr?
      if thing.class == Array
        head :ok, location: controller.url_for(thing.first)
      elsif thing.class == String
        head :ok, location: controller.url_for(thing)
      end
    else
      controller.redirect_to(thing.first, status_hash)
    end
  end
end
