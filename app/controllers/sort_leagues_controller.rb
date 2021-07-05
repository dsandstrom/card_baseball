# frozen_string_literal: true

class SortLeaguesController < ApplicationController
  before_action :set_league

  def update
    if @league.update(league_params)
      redirect_to leagues_url
    else
      render :edit
    end
  end

  private

    def set_league
      @league = League.find(params[:id])
    end

    def league_params
      params.require(:league).permit(:row_order_position)
    end
end
