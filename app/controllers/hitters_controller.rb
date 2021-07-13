# frozen_string_literal: true

class HittersController < ApplicationController
  before_action :set_team

  def index
    @hitters =
      if @team
        @team.hitters
      else
        Player.hitters.page(params[:page])
      end
  end

  private

    def set_team
      return unless params[:team_id]

      @team = Team.find(params[:team_id])
      @league = @team.league
    end
end
