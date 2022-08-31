class Admin::OffersController < AdminController
  before_action :set_offer, only: [:edit, :update, :destroy]

  def index
    @offers = Offer.all
    @offers = @offers.where(genre: params[:genre]) if params[:genre].present?
    @offers = @offers.where(status: params[:status]) if params[:status].present?
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to admin_offers_path, notice: 'Successfully Created'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      flash[:notice] = "Successfully updated!"
      redirect_to admin_offers_path
    else
      render :edit
    end
  end

  def destroy
    if @offer.destroy
      flash[:notice] = "Successfully deleted!"
    else
      flash[:alert] = @offer.errors.full_messages.join(', ')
    end
    redirect_to admin_offers_path
  end

  private

  def offer_params
    params.require(:offer).permit(:image, :name, :genre, :status, :amount, :coins)
  end

  def set_offer
    @offer = Offer.find(params[:id])
  end
end