# frozen_string_literal: true

# TODO: when create with a player with a roster, destroy old roster
# TODO: when dropping roster on current form, don't create a new one

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
    if @roster.valid?
      if unique?(@roster, current_roster)
        @roster.save
        current_roster&.destroy
      end
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

    def unique?(first, second)
      return true unless second

      value = %i[level player_id team_id position].all? do |attr|
        first.send(attr) == second.send(attr)
      end
      !value
    end
end
