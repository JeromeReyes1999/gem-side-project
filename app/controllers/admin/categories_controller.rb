class Admin::CategoriesController < AdminController
    before_action :set_category, only: [:edit, :update, :destroy]

    layout 'dashboard_layout'

    def index
      @categories= Category.all
    end

    def new
      @category = Category.new
    end

    def edit; end

    def update
      if @category.update(category_params)
        flash[:notice] = "Successfully updated!"
        redirect_to admin_categories_path
      else
        render :edit
      end
    end

    def destroy
      if @category.destroy
        flash[:notice] = "Successfully deleted!"
      else
        flash[:alert] = @category.errors.full_messages.join(', ')
      end
      redirect_to admin_categories_path
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        flash[:notice] = "Successfully created!"
        redirect_to admin_categories_path
      else
        render :new
      end
    end

    private

    def category_params
      params.require(:category).permit(:name)
    end

    def set_category
      @category = Category.find(params[:id])
    end
end
