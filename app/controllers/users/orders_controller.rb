class Users::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: :cancel
  before_action :set_offer, only: :create

  def cancel
    if @order.cancel!
      flash[:notice] = 'successfully cancelled'
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to users_detail_path(activities: 'orders')
  end

  def create
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

  def set_order
    @order = current_user.orders.submitted.find(params[:id])
  end
end