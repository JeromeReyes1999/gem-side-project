class Admin::CategoriesController < ApplicationController
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
        redirect_to admin_categories_path
      else
        render :edit
      end
    end

    def destroy
      unless @category.destroy
        flash[:alert] = "this category is currently in use in a post"
      else
        flash[:alert] = "deleted successfully"
      end
      redirect_to admin_categories_path
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path
      else
        render :new
      end
    end


    def category_params
      params.require(:category).permit(:name)
    end

    def set_category
      @category = Category.find(params[:id])
    end
end
