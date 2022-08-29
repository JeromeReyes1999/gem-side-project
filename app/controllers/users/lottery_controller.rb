class Users::LotteryController < ApplicationController
  before_action :set_item, only: [:show, :create]
  before_action :authenticate_user!, only: :create

  def index
    @items = Item.active.starting
    @items = @items.includes(:category).where(category: {name: params[:category]}) if params[:category].present?
    @categories = Category.all
  end

  def show
    begin
      Item.active.starting.find(params[:id])
      @bet = Bet.new
      @user_bets = @item.bets.where(user: current_user).where(batch_count: @item.batch_count)
    rescue ActiveRecord::RecordNotFound
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end

  def create
    begin
      loop_count = params[:bet][:coins].to_i
      params[:bet][:coins] = 1
      params[:bet][:item_id] = @item.id
      ActiveRecord::Base.transaction do
        loop_count.times do
          @bet = Bet.new(bet_params)
          @bet.user = current_user
          @bet.batch_count = @item.batch_count
          @bet.save!
        end
      end
      flash[:notice] = "successfully created"
    rescue ActiveRecord::RecordInvalid => exception
      flash[:alert] = exception
    end
    redirect_to users_lottery_index_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def bet_params
    params.require(:bet).permit(:coins, :item_id)
  end
end
