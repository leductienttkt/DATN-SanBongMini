class ProductsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @products = if params[:category_id].present?
      @domain.products.includes(:shop).by_category params[:category_id]
    elsif @domain.present?
      @domain.products.includes(:shop)
    else
      Product.all.includes(:shop)
    end.active.page(params[:page])
      .per Settings.common.products_per_page
  end

  def new
    @product = Product.new
  end

  def show
    if Product.exists? params[:id]
      @product = Product.find params[:id]
      @comment = @product.comments.build
      @comments = @product.comments.newest.includes :user
    else
      flash[:danger] = t "product.not_product"
      redirect_to products_path
    end
  end
end
