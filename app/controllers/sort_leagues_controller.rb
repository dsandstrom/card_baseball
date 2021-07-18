# frozen_string_literal: true

class SortLeaguesController < ApplicationController
  load_and_authorize_resource :league, parent: false

  def update
    if @league.update(league_params)
      redirect_to leagues_url
    else
      render :edit
    end
  end

  private

    def league_params
      params.require(:league).permit(:row_order_position)
    end
end
