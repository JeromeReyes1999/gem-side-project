class Admin::ItemsController  < AdminController

  before_action :set_items, only: [:edit, :update, :destroy]

  layout 'dashboard_layout'

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_items_path, notice: 'Successfully Submitted'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      redirect_to admin_items_path
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to admin_items_path, notice:  'Items successfully deleted'
    end
  end

  private

  def item_params
    params.require(:item).permit( :image, :name, :quantity,:minimum_bets, :online_at, :offline_at, :start_at, :category_id)
  end

  def set_items
    @item = Item.find(params[:id])
  end
end