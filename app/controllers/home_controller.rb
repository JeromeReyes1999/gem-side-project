class HomeController < ApplicationController
  def index
    @winners = Winner.includes(:user).published.order(id: :desc)
    @items = Item.active.starting.order(id: :desc)
  end
end
