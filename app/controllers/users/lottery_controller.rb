class Users::LotteryController < ApplicationController
  before_action :set_item, only: [:show, :create]
  before_action :authenticate_user!, only: :create

  def index
    @items = Item.active.starting
    @items = @items.includes(:category).where(category: {name: params[:category]}) if params[:category].present?
    @categories = Category.all
  end

  def show
    @bet = Bet.new
    @user_bets = @item.bets.where(user: current_user).where(batch_count: @item.batch_count)
  end

  def create
    begin
      # very slow when coins are larger
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

  #for review- 1000x faster but doesn't trigger callbacks
  # def create
  #   begin
  #   ActiveRecord::Base.transaction do
  #         loop_count = params[:bet][:coins].to_i
  #         params[:bet][:coins] = 1
  #         params[:bet][:item_id] = @item.id
  #         params[:bet][:created_at] = Time.now
  #         params[:bet][:updated_at] = Time.now
  #         params[:bet][:batch_count] = @item.batch_count
  #         params[:bet][:user_id] = current_user.id
  #         bet_arr = loop_count.times.map{bet_params}
  #         Bet.insert_all!(bet_arr)
  #       end
  #     flash[:notice] = "successfully created"
  #   rescue ActiveRecord::RecordInvalid => exception
  #     flash[:alert] = exception
  #   end
  #   redirect_to users_lottery_index_path
  # end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def bet_params
    params.require(:bet).permit(:coins, :item_id)
  end
end