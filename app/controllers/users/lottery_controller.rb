class Users::LotteryController < ApplicationController
  before_action :set_item, only: [:create, :show]
  before_action :authenticate_user!, only: :create

  def index
    @items = Item.active.starting
    @items = @items.includes(:category).where(category: {name: params[:category]}) if params[:category].present?
    @categories = Category.all
  end

  def show
    @bet = Bet.new
    @user_bets = @item.bets.where(user: current_user).batch_active_bets(@item.batch_count)
  end

  def create
      begin
        loop_count = params[:bet][:coins].to_i
        ActiveRecord::Base.transaction do
          loop_count.times do
            @bet = Bet.new(bet_params)
            @bet.user = current_user
            @bet.item = @item
            @bet.coins = 1
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
    unless @item = Item.active.starting.find_by_id(params[:id])
      flash[:alert] = 'Item is either inactive or not existing'
      redirect_to users_lottery_index_path
    end
  end

  def bet_params
    params.require(:bet).permit(:coins, :item_id)
  end
end
