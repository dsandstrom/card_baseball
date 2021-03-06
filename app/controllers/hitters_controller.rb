# frozen_string_literal: true

class HittersController < ApplicationController
  before_action :set_team
  before_action :authorize_player

  def index
    @hitters =
      if @team
        @team.hitters.filter_by(build_filters)
      else
        Player.hitters.filter_by(build_filters(order: 'offense'))
              .page(params[:page])
      end
  end

  private

    def set_team
      return unless params[:team_id]

      @team = Team.find(params[:team_id])
      authorize! :read, @team
      @league = @team.league
    end
end
