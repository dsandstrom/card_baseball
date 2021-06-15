# frozen_string_literal: true

class HittersController < ApplicationController
  ALLOWED_ATTRS =
    %i[first_name middle_name last_name roster_name bats bunt_grade speed
       durability primary_position hitting_pitcher overall_rating left_rating
       right_rating left_on_base_percentage left_slugging left_homeruns
       right_on_base_percentage right_slugging right_homeruns catcher_defense
       first_base_defense second_base_defense third_base_defense
       shortstop_defense center_field_defense outfield_defense pitcher_defense
       catcher_bar pitcher_bar].freeze

  before_action :set_hitter, only: %i[show edit update destroy]

  def index
    @hitters = Hitter.all
  end

  def show
    @contract = @hitter.contract
  end

  def new
    @hitter = Hitter.new
  end

  def edit; end

  def create
    @hitter = Hitter.new(hitter_params)
    @hitter.set_roster_name

    if @hitter.save
      redirect_to @hitter, notice: 'Hitter was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @hitter.assign_attributes(hitter_params)
    @hitter.set_roster_name

    if @hitter.save
      redirect_to @hitter, notice: 'Hitter was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hitter.destroy
    redirect_to hitters_url, notice: 'Hitter was successfully removed.'
  end

  private

    def set_hitter
      @hitter = Hitter.find(params[:id])
    end

    def hitter_params
      params.require(:hitter).permit(ALLOWED_ATTRS)
    end
end
