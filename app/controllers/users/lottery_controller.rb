class Users::LotteryController < ApplicationController
  layout 'home_layout'

  def lottery_page
    @category = Category.find_by_name(params[:category])
    @items = Item.where(status: 'Active').where(state:'starting')
    @items = @items.where(category_id: @category&.id) if params[:category]
    @categories = Category.all
  end
end