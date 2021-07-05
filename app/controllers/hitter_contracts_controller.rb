# frozen_string_literal: true

class HitterContractsController < ApplicationController
  before_action :set_hitter
  before_action :set_hitter_contract
  before_action :set_leagues, only: :edit

  def edit
    @hitter_contract = @hitter.contract || @hitter.build_contract
  end

  def update
    @hitter_contract.assign_attributes(hitter_contract_params)
    if @hitter_contract.save
      redirect_to @hitter,
                  notice: "#{@hitter.name}'s contract was successfully updated."
    else
      set_leagues
      render :edit
    end
  end

  def destroy
    @hitter.contract&.destroy
    redirect_to @hitter,
                notice: "#{@hitter.name}'s contract was successfully removed."
  end

  private

    def set_hitter
      @hitter = Hitter.find(params[:hitter_id])
    end

    def set_leagues
      @leagues = League.rank(:row_order).preload(:teams)
    end

    def set_hitter_contract
      @hitter_contract = @hitter.contract || @hitter.build_contract
    end

    def hitter_contract_params
      params.require(:hitter_contract).permit(:team_id, :length)
    end
end
