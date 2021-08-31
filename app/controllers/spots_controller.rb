# frozen_string_literal: true

class SpotsController < ApplicationController
  load_and_authorize_resource :lineup
  load_and_authorize_resource through: :lineup
  before_action :set_team

  def new
    respond_to do |format|
      format.html { render :new }
      format.js do
        @spot.batting_order = params.delete(:batting_order)
        bench_player_id = params.delete(:bench_player_id)
        @bench_player = Player.find(bench_player_id) if bench_player_id
        render :destroy
      end
    end
  end

  def edit; end

  def create
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
    @bench_player = @spot.player
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

    def set_team
      @team = @lineup.team
      @league = @team.league
    end

    def spot_params
      params.require(:spot).permit(:player_id, :position, :batting_order)
    end

    def update_params
      params.require(:spot).permit(:player_id, :position)
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
      player = @spot.player
      return unless player

      old_spot = @lineup.spots.find_by(player_id: player.id)
      return unless old_spot

      @spot.position = old_spot.position
      @new_spot = @lineup.spots.build(batting_order: old_spot.batting_order)
      old_spot.destroy
    end

    def update_spot
      old_player = @spot.player
      old_position = @spot.position
      @spot.assign_attributes(update_params)
      @old_spot = @lineup.spots.find_by(player_id: @spot.player_id)
      return if old_player == @spot.player

      if @old_spot
        switch_spots(old_player, old_position)
      else
        @bench_player = old_player
      end
    end

    def switch_spots(player, position)
      @spot.position = @old_spot.position
      @old_spot.update_columns(player_id: player.id, position: position)
    end
end
