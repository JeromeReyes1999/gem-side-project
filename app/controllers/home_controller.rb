class HomeController < ApplicationController
  def index
    @winners = Winner.includes(:user).published.first(2)
  end
end
