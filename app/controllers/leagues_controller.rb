# frozen_string_literal: true

class LeaguesController < ApplicationController
  before_action :set_league, only: %i[show edit update destroy]

  # GET /leagues or /leagues.json
  def index
    @leagues = League.all
  end

  # GET /leagues/1 or /leagues/1.json
  def show
    @teams = @league.teams
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit; end

  # POST /leagues or /leagues.json
  def create
    @league = League.new(league_params)

    respond_to do |format|
      if @league.save
        format.html do
          redirect_to @league, notice: 'League was successfully created.'
        end
        format.json { render :show, status: :created, location: @league }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @league.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /leagues/1 or /leagues/1.json
  def update
    respond_to do |format|
      if @league.update(league_params)
        format.html do
          redirect_to @league, notice: 'League was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @league.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /leagues/1 or /leagues/1.json
  def destroy
    @league.destroy
    respond_to do |format|
      format.html do
        redirect_to leagues_url, notice: 'League was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_league
      @league = League.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def league_params
      params.require(:league).permit(:name)
    end
end
