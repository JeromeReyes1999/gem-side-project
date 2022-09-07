class Users::WinnersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_winner
  before_action :set_address, only: :update

  def show; end

  def update
    if @winner.update(address: @address) && @winner.claim!
      flash[:notice] = "Successfully updated!"
      redirect_to users_detail_path(activities: 'winning')
    else
      render :show
    end
  end

  private

  def set_winner
    @winner = Winner.where(user: current_user).won.find(params[:id])
  end

  def set_address
    @address = current_user.addresses.find(params[:winner][:address])
  end
end