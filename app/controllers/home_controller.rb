class HomeController < ApplicationController
  before_action :authenticate_user!

  layout "home_layout"

  def index; end
end
