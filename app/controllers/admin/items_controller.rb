class Admin::ItemsController  < AdminController
  before_action :set_items, only: [:edit, :update, :destroy]

  def index
    @items = Item.includes(:category)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_items_path, notice: 'Successfully Created'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      flash[:notice] = "Successfully updated!"
      redirect_to admin_items_path
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      flash[:notice] = "Successfully deleted!"
    else
      flash[:alert] = @item.errors.full_messages.join(', ')
    end
    redirect_to admin_items_path
  end

  private

  def item_params
    params.require(:item).permit( :image, :name, :quantity,:minimum_bets, :online_at, :offline_at, :start_at, :category_id)
  end

  def set_items
    @item = Item.find(params[:id])
  end
end