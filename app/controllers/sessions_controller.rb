# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  respond_to :html, :json

  # As written, this method does nothing necessary
  # def new
  #  super
  # end

  # As written, this method does nothing necessary
  # def create
  #  super
  # end
end
