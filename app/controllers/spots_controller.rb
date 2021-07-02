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
    move_from_another_spot

    respond_to do |format|
      format.html { html_create_response }
      format.js { js_create_response }
    end
  end

  def update
    respond_to do |format|
      format.html { html_update_response }
      format.js { js_update_response }
    end
  end

  def destroy
    @bench_hitter = @spot.hitter
    batting_order = @spot.batting_order
    @spot.destroy

    respond_to do |format|
      format.html do
        redirect_to redirect_url,
                    notice: 'Batting spot was successfully cleared.'
      end
      format.js { @spot = @lineup.spots.build(batting_order: batting_order) }
    end
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

    def update_params
      params.require(:spot).permit(:hitter_id, :position)
    end

    def html_create_response
      if @spot.save
        redirect_to redirect_url,
                    notice: 'Batting spot was successfully set.'
      else
        render :new
      end
    end

    def js_create_response
      if @spot.save
        render :show
      else
        render :new
      end
    end

    def html_update_response
      if @spot.update(update_params)
        redirect_to redirect_url,
                    notice: 'Batting spot was successfully changed.'
      else
        render :edit
      end
    end

    def js_update_response
      update_spot

      if @spot.save
        render :show
      else
        render :edit
      end
    end

    def redirect_url
      team_lineup_path(@team, @lineup)
    end

    def move_from_another_spot
      hitter = @spot.hitter
      return unless hitter

      old_spot = @lineup.spots.find_by(hitter_id: hitter.id)
      return unless old_spot

      @spot.position = old_spot.position
      @new_spot = @lineup.spots.build(batting_order: old_spot.batting_order)
      old_spot.destroy
    end

    def update_spot
      old_hitter = @spot.hitter
      old_position = @spot.position
      @spot.assign_attributes(update_params)
      @old_spot = @lineup.spots.find_by(hitter_id: @spot.hitter_id)
      return if old_hitter == @spot.hitter

      if @old_spot
        switch_spots(old_hitter, old_position)
      else
        @bench_hitter = old_hitter
      end
    end

    def switch_spots(hitter, position)
      @spot.position = @old_spot.position
      @old_spot.update_columns(hitter_id: hitter.id, position: position)
    end
end
