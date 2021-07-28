# frozen_string_literal: true

class RostersController < ApplicationController
  load_and_authorize_resource :team
  load_and_authorize_resource through: :team
  before_action :set_league

  def index
    @rosters_level1 = @team.rosters.where(level: 1)
    @rosters_level2 = @team.rosters.where(level: 2)
    @rosters_level3 = @team.rosters.where(level: 3)
    @rosters_level4 = @team.rosters.where(level: 4)
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
end
