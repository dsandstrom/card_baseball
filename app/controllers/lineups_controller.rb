# frozen_string_literal: true

class LineupsController < ApplicationController
  before_action :convert_params, only: %i[create update]
  load_and_authorize_resource :team
  load_and_authorize_resource through: :team
  before_action :set_league

  def index
    @lineups = @lineups.order(name: :asc, away: :desc, vs: :asc, with_dh: :asc)
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
      params.require(:lineup).permit(:name, :vs, :with_dh, :away)
    end

    def convert_params
      return unless params && params[:lineup]

      params[:lineup].each do |key, value|
        next unless value == 'all'

        params[:lineup][key] = ''
      end
    end
end
