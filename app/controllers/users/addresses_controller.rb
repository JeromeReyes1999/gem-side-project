class Users::AddressesController  < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @addresses = current_user.addresses
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user
    if @address.save
      flash[:notice] = "Successfully created!"
      redirect_to users_addresses_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      flash[:notice] = "Successfully updated!"
      redirect_to users_addresses_path
    else
      render :edit
    end
  end

  def destroy
    if @address.destroy
      flash[:notice] = "Successfully deleted!"
    else
      flash[:alert] = @address.errors.full_messages.join(', ')
    end
    redirect_to users_addresses_path
  end

  def get_provinces_by_region
    @provinces = Region.find_by_id(params[:id]).provinces
    render json: { province: @provinces }
  end

  def get_cities_by_province
    @cities = Province.find_by_id(params[:id]).cities
    render json: { city: @cities }
  end

  def get_barangays_by_city
    @barangays = City.find_by_id(params[:id]).barangays
    render json: { barangay: @barangays }
  end

  private

  def address_params
    params.require(:address).permit( :genre, :is_default, :name, :street_address, :phone_number, :region_id, :province_id, :city_id, :barangay_id, :remark)
  end

  def set_address
    @address = Address.find(params[:id])
  end
end