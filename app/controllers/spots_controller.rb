# frozen_string_literal: true

class SpotsController < ApplicationController
  before_action :set_lineup
  before_action :set_spot, only: %i[show edit update destroy]

  def new
    @spot = @lineup.spots.build
  end

  def edit; end

  def create
    @spot = @lineup.spots.build(spot_params)

    if @spot.save
      redirect_to redirect_url,
                  notice: 'Batting spot was successfully set.'
    else
      render :new
    end
  end

  def update
    if @spot.update(spot_params)
      redirect_to redirect_url,
                  notice: 'Batting spot was successfully changed.'
    else
      render :edit
    end
  end

  def destroy
    @spot.destroy
    redirect_to redirect_url,
                notice: 'Batting spot was successfully cleared.'
  end

  private

    def set_lineup
      @lineup = Lineup.find(params[:lineup_id])
      @team = @lineup.team
      @league = @team.league
    end

    def set_spot
      @spot = @lineup.spots.find(params[:id])
    end

    def spot_params
      params.require(:spot).permit(:hitter_id, :position, :batting_order)
    end

    def redirect_url
      team_lineup_path(@team, @lineup)
    end
end
