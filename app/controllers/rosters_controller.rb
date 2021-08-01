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
    current_roster = Roster.where(player_id: @roster.player_id)
                           .where('id IS NOT NULL').first
    if valid_except_player?(@roster, current_roster) && @roster.save
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

    def valid_except_player?(roster, current)
      return true unless current
      return true if roster.valid?
      return false unless unique?(roster, current)

      errors = roster.errors.errors
      return false unless errors.count == 1

      error = errors.first
      return false unless error.attribute == :player_id && error.type == :taken

      current.destroy
      true
    end

    def unique?(first, second)
      return true unless second

      value = %i[level team_id position].all? do |attr|
        first.send(attr) == second.send(attr)
      end
      !value
    end
end
