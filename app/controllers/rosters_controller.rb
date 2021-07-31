# frozen_string_literal: true

class RostersController < ApplicationController
  load_and_authorize_resource :team
  load_and_authorize_resource through: :team
  before_action :set_league

  def index
    build_rosters
  end

  def new; end

  def edit; end

  def create
    if @roster.save
      redirect_to team_rosters_url(@team),
                  notice: 'Roster spot was successfully created.'
    else
      render :new
    end
  end

  def update
    if @roster.update(roster_params)
      redirect_to team_rosters_url(@team),
                  notice: 'Roster spot was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @roster.destroy
    redirect_to team_rosters_url(@team),
                notice: 'Roster spot was successfully removed.'
  end

  private

    def set_league
      @league = @team.league
    end

    def roster_params
      params.require(:roster).permit(:player_id, :level, :position)
    end

    def build_rosters
      @level1_rosters = @team.rosters.where(level: 1)
      @level2_rosters = @team.rosters.where(level: 2)
      @level3_rosters = @team.rosters.where(level: 3)
      @level4_rosters = @team.rosters.where(level: 4)
      @players = @team.players
      @rosterless_players = @team.players.left_outer_joins(:roster)
                                 .where('rosters.id IS NULL')
    end
end
