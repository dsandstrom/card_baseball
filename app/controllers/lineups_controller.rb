# frozen_string_literal: true

class LineupsController < ApplicationController
  load_and_authorize_resource :team
  load_and_authorize_resource through: :team
  before_action :set_league

  def index
    @lineups = @lineups.order(name: :asc, vs: :asc, with_dh: :asc)
  end

  def show
    @spots = @lineup.spots
    @players = @lineup.players
    @bench = @lineup.bench
  end

  def new; end

  def edit; end

  def create
    if @lineup.save
      unless @lineup.with_dh?
        @lineup.spots.create(position: 1, batting_order: 9)
      end
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

    def set_league
      @league = @team.league
    end

    def lineup_params
      params.require(:lineup).permit(:name, :vs, :with_dh)
    end
end
