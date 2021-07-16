# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied, with: :user_not_authorized

  private

    def user_not_authorized
      respond_to do |format|
        format.json { head :forbidden, content_type: 'text/html' }
        format.html { redirect_to main_app.unauthorized_url }
        format.js   { head :forbidden, content_type: 'text/html' }
      end
    end
end
