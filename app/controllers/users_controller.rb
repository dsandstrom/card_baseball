# frozen_string_literal: true

# TODO: allow admin to create user (invite without password)
# TODO: add user dropdown

class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = @users.order(name: :asc)
  end

  def show
    @teams = @user.teams
  end

  def new
    @user.time_zone = 'Pacific Time (US & Canada)'
  end

  def edit; end

  def create
    if @user.save
      redirect_to users_url, notice: 'User was successfully added.'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully removed.'
  end

  private

    def user_params
      if current_user.admin? && current_user != @user
        params.require(:user)
              .permit(:name, :email, :city, :time_zone, :admin_role)
      else
        params.require(:user).permit(:name, :email, :city, :time_zone)
      end
    end
end
