# frozen_string_literal: true

class ApplicationController < ActionController::Base
  FILTER_OPTIONS = %i[order query free_agent position1 position2 position3
                      position4 position5 position6 position7 position8 bats
                      bunt_grade speed throws pitcher_type].freeze

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

    def authorize_player
      authorize! :read, Player
    end

    def build_filters(defaults = {})
      filters = defaults
      FILTER_OPTIONS.each do |param|
        filters[param] = params[param]
      end
      if filters[:query].present?
        filters[:query] = filters[:query].truncate(80, omission: '')
      end
      filters
    end
end
