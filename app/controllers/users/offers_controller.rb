class Users::OffersController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    @offers = Offer.active
  end
end