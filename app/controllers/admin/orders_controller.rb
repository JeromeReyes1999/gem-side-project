class Admin::OrdersController < AdminController
  before_action :set_order, except: [:new, :create, :index]
  before_action :set_user, only: [:new, :create]

  def index
    @orders = Order.includes(:user, :offer)
    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.where(user: {email: params[:email]}) if params[:email].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(offer: {name: params[:offer_name]}) if params[:offer_name].present?
    @orders = @orders.where(created_at: params[:from].to_datetime..params[:to].to_datetime) if params[:from].present? && params[:to].present?

    @amount_subtotal = @orders.sum(:amount)
    @amount_total = Order.sum(:amount)
    @coin_subtotal = @orders.sum(:coin)
    @coin_total = Order.sum(:coin)
  end

  def pay
      if @order.pay!
        flash[:notice] = 'successfully paid!!'
      else
        flash[:alert] = @order.errors.full_messages.join(', ')
      end
      redirect_to request.referrer
  end

  def cancel
    if @order.cancel!
      flash[:notice] = 'successfully cancelled!!'
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to request.referrer
  end

  def new
    @order = Order.new
  end

 def create
    @order = Order.new(order_params)
    @order.genre = params[:genre]
    @order.user = @user
    if @order.save
      if @order.may_pay? && @order.pay!
        flash[:notice]= 'Successfully Created'
      else
        flash[:alert]= @order.errors.full_messages.join(", ")
        @order.cancel!
      end
      redirect_to admin_user_new_order_path(genre: params[:genre])
    else
      render :new
    end
  end

  private

  def order_params
    if params[:genre] == 'member_level'
      params.require(:order).permit(:coin)
    else
      params.require(:order).permit(:remarks, :coin)
    end
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_order
    @order = Order.find(params[:order_id])
  end
end
