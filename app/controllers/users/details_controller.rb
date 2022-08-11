class Users::DetailsController < ApplicationController
  before_action :authenticate_user!

  layout "home_layout"

  def show; end
end