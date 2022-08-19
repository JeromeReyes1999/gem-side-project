class Users::LotteryController < ApplicationController

  def lottery_page
    @items = Item.active.starting
    @items = @items.includes(:category).where(category: {name: params[:category]}) if params[:category].present?
    @categories = Category.all
  end
end