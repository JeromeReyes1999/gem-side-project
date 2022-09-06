class Users::DetailsController < ApplicationController
  before_action :authenticate_user!

  def show
    @orders = Order.where(user: current_user) if params[:activities] == 'orders' || params[:activities].blank?
    @invitations = User.where(parent: current_user) if params[:activities] == 'invites'
    @bets = Bet.includes(:item).where(user: current_user) if params[:activities] == 'gacha'
    @winners = Winner.includes(:item).where(user: current_user) if params[:activities] == 'winning'
  end
end