# frozen_string_literal: true

# TODO: add move team controller or action

class TeamsController < ApplicationController
  before_action :set_league, except: :index
  before_action :set_team, only: %i[show edit update destroy]

  # GET /teams or /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1 or /teams/1.json
  def show; end

  # GET /teams/new
  def new
    @team = @league.teams.build
  end

  # GET /teams/1/edit
  def edit; end

  # POST /teams or /teams.json
  def create
    @team = @league.teams.build(team_params)

    respond_to do |format|
      if @team.save
        format.html do
          redirect_to league_team_path(@league, @team),
                      notice: 'Team was successfully created.'
        end
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html do
          redirect_to league_team_path(@league, @team),
                      notice: 'Team was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html do
        redirect_to @league, notice: 'Team was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_league
      @league = League.find(params[:league_id])
    end

    def set_team
      @team = @league.teams.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name, :icon)
    end
end
