# frozen_string_literal: true

class ContractsController < ApplicationController
  load_and_authorize_resource :player
  before_action :set_contract
  before_action :set_leagues, only: :edit

  def edit
    @contract = @player.contract || @player.build_contract
  end

  def update
    @contract.assign_attributes(contract_params)
    if @contract.save
      redirect_to @player,
                  notice: "#{@player.name}'s contract was successfully updated."
    else
      set_leagues
      render :edit
    end
  end

  def destroy
    @player.contract&.destroy
    redirect_to @player,
                notice: "#{@player.name}'s contract was successfully removed."
  end

  private

    def set_player
      @player = Player.find(params[:player_id])
    end

    def authorize_resource(resource)
      if resource.persisted?
        authorize! :update, resource
      else
        authorize! :create, resource
      end
    end

    def set_contract
      @contract = @player.contract || @player.build_contract
      authorize_resource @contract
    end

    def set_leagues
      @leagues = League.rank(:row_order).preload(:teams)
    end

    def contract_params
      params.require(:contract).permit(:team_id, :length)
    end
end
