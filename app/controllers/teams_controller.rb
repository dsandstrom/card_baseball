# frozen_string_literal: true

# TODO: add move team controller or action
# TODO: add pitcher rotations page

class TeamsController < ApplicationController
  load_and_authorize_resource :league
  load_and_authorize_resource through: :league

  def show
    @players = @team.players.order(last_name: :asc, roster_name: :asc)
  end

  def new; end

  def edit; end

  def create
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

    def team_params
      params.require(:team).permit(:name, :identifier, :logo, :user_id)
    end
end
