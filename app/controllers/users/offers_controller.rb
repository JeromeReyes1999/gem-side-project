class Users::OffersController < ApplicationController
  before_action :authenticate_user!, only: :index
  before_action :set_offer, only: :order

  def index
    @offers = Offer.active
  end

  def order
    @order = Order.new
    @order.amount = @offer.amount
    @order.coin = @offer.coins
    @order.user = current_user
    @order.genre = :deposit
    @order.offer = @offer
    if @order.save
      if @order.may_submit? && @order.submit!
        flash[:notice] = "Your order is successful!!"
      else
        flash[:alert]= @order.errors.full_messages.join(", ")
        @order.cancel!
      end
      redirect_to users_offers_path
    else
      flash[:alert] = @order.errors.full_messages.join(', ') || "order failed!!"
      render :index
    end
  end

  private

  def set_offer
    @offer = Offer.active.find(params[:offer_id])
  end

end