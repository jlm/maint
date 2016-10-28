class SessionsController < Devise::SessionsController
  respond_to :html, :json

  def new
    super
  end

  def create
    super
  end

end
