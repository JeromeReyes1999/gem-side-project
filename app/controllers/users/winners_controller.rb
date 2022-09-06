class Users::WinnersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_winner
  before_action :set_address, only: :update

  def show; end

  def update
    if @winner.claim!
      if @winner.update(address: @address)
        flash[:notice] = "Successfully updated!"
        redirect_to users_addresses_path
      else
        render :edit
      end
    else
      render :edit
    end
  end

  private

  def set_winner
    @winner = Winner.where(user: current_user).find(params[:id])
  end

  def set_address
    @address = Address.where(user: current_user).find(params[:winner][:address])
  end
end