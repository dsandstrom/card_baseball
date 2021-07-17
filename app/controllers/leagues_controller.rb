# frozen_string_literal: true

class LeaguesController < ApplicationController
  load_and_authorize_resource

  def index
    @leagues = @leagues.rank(:row_order).preload(:teams)
  end

  def show
    @teams = @league.teams.order(name: :asc)
  end

  def new; end

  def edit; end

  def create
    if @league.save
      redirect_to leagues_url,
                  notice: "#{@league.name} was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @league.update(league_params)
      redirect_to @league,
                  notice: "#{@league.name} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    name = @league.name
    @league.destroy
    redirect_to leagues_url, notice: "#{name} was successfully destroyed."
  end

  private

    def league_params
      params.require(:league).permit(:name)
    end
end
