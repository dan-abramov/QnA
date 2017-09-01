require "application_responder"

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.js   { render 'partials/exception', locals: {exception: exception.message} }
      format.json { render [exception.message], status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?
end
