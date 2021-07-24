# frozen_string_literal: true

# TODO: allow users to "sticky" players (session)
# keeps them at the top so they can compare to other players
# TODO: allow users to "watch" players when thinking about trades (database)
# TODO: allow seaching/filtering

class PlayersController < ApplicationController
  ALLOWED_ATTRS =
    %i[first_name nick_name last_name roster_name bats bunt_grade speed
       offensive_durability primary_position hitting_pitcher offensive_rating
       left_hitting right_hitting left_on_base_percentage left_slugging
       left_homerun right_on_base_percentage right_slugging right_homerun
       defense1 defense2 defense3 defense4 defense5 defense6 defense7 defense8
       bar1 bar2].freeze

  load_and_authorize_resource

  def index
    @players = @players.filter_by(build_filters(order: 'name'))
                       .page(params[:page])
  end

  def show
    @contract = @player.contract
  end

  def new; end

  def edit; end

  def create
    @player.set_roster_name

    if @player.save
      redirect_to @player, notice: 'Player was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @player.assign_attributes(player_params)
    @player.set_roster_name

    if @player.save
      redirect_to @player, notice: 'Player was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @player.destroy
    redirect_to players_url, notice: 'Player was successfully removed.'
  end

  private

    def player_params
      params.require(:player).permit(ALLOWED_ATTRS)
    end
end
