# frozen_string_literal: true

# TODO: add move team controller or action

class TeamsController < ApplicationController
  before_action :set_league, except: :index
  before_action :set_team, only: %i[show edit update destroy]

  def index
    @teams = Team.all
  end

  def show
    # TODO: show all players, with just positions
    # TODO: show hitter details on another page, add pitcher rotations page
    @hitters = @team.hitters
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
      params.require(:team).permit(:name, :logo)
    end
end
