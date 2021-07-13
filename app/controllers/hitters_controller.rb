# frozen_string_literal: true

# TODO: allow without team

class HittersController < ApplicationController
  before_action :set_team

  def index
    @hitters = @team.hitters
  end

  private

    def set_team
      @team = Team.find(params[:team_id])
      @league = @team.league
    end
end
