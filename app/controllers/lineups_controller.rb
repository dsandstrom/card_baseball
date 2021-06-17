# frozen_string_literal: true

class LineupsController < ApplicationController
  before_action :set_team
  before_action :set_lineup, only: %i[show edit update destroy]

  def index
    @lineups = @team.lineups
  end

  def show; end

  def new
    @lineup = @team.lineups.build
  end

  def edit; end

  def create
    @lineup = @team.lineups.build(lineup_params)

    if @lineup.save
      redirect_to team_lineup_url(@team, @lineup),
                  notice: 'Lineup was successfully added.'
    else
      render :new
    end
  end

  def update
    if @lineup.update(lineup_params)
      redirect_to team_lineup_url(@team, @lineup),
                  notice: 'Lineup was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @lineup.destroy
    redirect_to team_lineups_url(@team),
                notice: 'Lineup was successfully removed.'
  end

  private

    def set_team
      @team = Team.find(params[:team_id])
      @league = @team.league
    end

    def set_lineup
      @lineup = @team.lineups.find(params[:id])
    end

    def lineup_params
      params.require(:lineup).permit(:name, :vs, :with_dh)
    end
end
