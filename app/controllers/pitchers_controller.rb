# frozen_string_literal: true

class PitchersController < ApplicationController
  before_action :set_team

  def index
    @pitchers =
      if @team
        @team.pitchers
      else
        Player.pitchers.order(pitcher_rating: :desc).page(params[:page])
      end
  end

  private

    def set_team
      return unless params[:team_id]

      @team = Team.find(params[:team_id])
      @league = @team.league
    end
end
