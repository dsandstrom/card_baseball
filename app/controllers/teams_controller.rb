# frozen_string_literal: true

# TODO: add move team controller or action
# TODO: add pitcher rotations page

class TeamsController < ApplicationController
  before_action :set_league, except: :index
  before_action :set_team, only: %i[show edit update destroy]

  def index
    @teams = Team.all
  end

  def show
    @players = @team.players.order(last_name: :asc, roster_name: :asc)
  end

  def new
    @team = @league.teams.build
  end

  def edit; end

  def create
    @team = @league.teams.build(team_params)

    if @team.save
      redirect_to @league, notice: 'Team was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @team.update(team_params)
      redirect_to league_team_path(@league, @team),
                  notice: 'Team was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    redirect_to @league, notice: 'Team was successfully destroyed.'
  end

  private

    def set_league
      @league = League.find(params[:league_id])
    end

    def set_team
      @team = @league.teams.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :identifier, :logo, :user_id)
    end
end
