# frozen_string_literal: true

class PitchersController < ApplicationController
  before_action :set_team
  before_action :authorize_player

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
      authorize! :read, @team
      @league = @team.league
    end
end
