class Admin::BannersController < AdminController
  before_action :set_banner, only: [:edit, :update, :destroy]

  def index
    @banners= Banner.all
  end

  def new
    @banner = Banner.new
  end

  def edit; end

  def update
    if @banner.update(banner_params)
      flash[:notice] = "Successfully updated!"
      redirect_to admin_banners_path
    else
      render :edit
    end
  end

  def destroy
    if @banner.destroy
      flash[:notice] = "Successfully deleted!"
    else
      flash[:alert] = @banner.errors.full_messages.join(', ')
    end
    redirect_to admin_banners_path
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      flash[:notice] = "Successfully created!"
      redirect_to admin_banners_path
    else
      render :new
    end
  end

  private

  def banner_params
    params.require(:banner).permit(:status, :preview, :offline_at, :online_at)
  end

  def set_banner
    @banner = Banner.find(params[:id])
  end
end
