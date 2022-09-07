class Users::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order

  def cancel
    if @order.cancel!
      flash[:notice] = 'successfully cancelled'
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to users_detail_path(activities: 'orders')
  end

  private

  def set_order
    @order = current_user.orders.submitted.find(params[:id])
  end
end