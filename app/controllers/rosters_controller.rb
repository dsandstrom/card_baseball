# frozen_string_literal: true

class RostersController < ApplicationController
  load_and_authorize_resource :team
  load_and_authorize_resource through: :team, except: :create
  before_action :set_league

  def index
    build_rosters
  end

  def new; end

  def edit; end

  def create
    respond_to do |format|
      format.html { create_html_response }
      format.js { create_js_response }
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
      @rosters = @team.rosters
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

    def create_html_response
      @roster = @team.rosters.build(roster_params)
      authorize! :create, @roster

      if @roster.save
        redirect_to team_rosters_url(@team),
                    notice: 'Roster spot was successfully created.'
      else
        render :new
      end
    end

    def create_js_response
      @player = Player.find_by(id: roster_params[:player_id])
      # TODO: verify original roster is same team before updating
      @roster = @player&.roster || @team.rosters.build
      old_position = @roster.position
      old_level = @roster.level
      @roster.assign_attributes(roster_params)
      authorize! :create, @roster

      @rosters = @team.rosters
      if @roster.save
        unless @roster.position == old_position && @roster.level == old_level
          @old_position = old_position
          @old_level = old_level
        end
        render :show
      else
        @rosterless_player = @player
        render :new
      end
    end
end
