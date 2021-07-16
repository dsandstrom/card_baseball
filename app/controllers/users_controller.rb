# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %w[show edit update destroy]

  def index
    @users = User.all
  end

  def show
    @teams = @user.teams
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_create_params)

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

    def set_user
      @user = User.find(params[:id])
    end

    def user_create_params
      params.require(:user)
            .permit(:name, :email, :admin_role, :city, :time_zone, :password,
                    :password_confirmation)
    end

    def user_params
      params.require(:user).permit(:name, :email, :city, :time_zone)
    end

    def admin_params
      params.require(:user)
            .permit(:name, :email, :admin_role, :city, :time_zone)
    end
end
