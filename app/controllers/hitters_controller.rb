# frozen_string_literal: true

class HittersController < ApplicationController
  before_action :set_hitter, only: %i[show edit update destroy]

  # GET /hitters or /hitters.json
  def index
    @hitters = Hitter.all
  end

  # GET /hitters/1 or /hitters/1.json
  def show; end

  # GET /hitters/new
  def new
    @hitter = Hitter.new
  end

  # GET /hitters/1/edit
  def edit; end

  # POST /hitters or /hitters.json
  def create
    @hitter = Hitter.new(hitter_params)

    respond_to do |format|
      if @hitter.save
        format.html do
          redirect_to @hitter, notice: 'Hitter was successfully created.'
        end
        format.json { render :show, status: :created, location: @hitter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @hitter.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /hitters/1 or /hitters/1.json
  def update
    respond_to do |format|
      if @hitter.update(hitter_params)
        format.html do
          redirect_to @hitter, notice: 'Hitter was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @hitter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @hitter.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /hitters/1 or /hitters/1.json
  def destroy
    @hitter.destroy
    respond_to do |format|
      format.html do
        redirect_to hitters_url, notice: 'Hitter was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_hitter
      @hitter = Hitter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hitter_params
      params.require(:hitter).permit(:first_name, :middle_name, :last_name,
                                     :roster_name, :bats, :bunt, :speed, :durability, :overall_rating, :left_rating, :right_rating, :left_on_base_percentage, :left_slugging, :left_homeruns, :right_on_base_percentage, :right_slugging, :right_homeruns, :catcher_defense, :first_base_defense, :second_base_defense, :third_base_defense, :short_stop_defense, :center_field_defense, :outfield_defense, :pitcher_defense, :catcher_bar, :pitcher_bar)
    end
end
