class ProductsController < ApplicationController
  def index
    @products = Product.all.includes(:category)

    # Keyword search across product names and descriptions
    if params[:search].present?
      @products = @products.where('name ILIKE :search OR description ILIKE :search', search: "%#{params[:search]}%")
    end

    # Filter by category_id if the parameter is provided
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?

    # Filter for on-sale products
    @products = @products.where(onSale: true) if params[:on_sale] == '1'

    # Filter for new products (added within the last 3 days)
    @products = @products.where('created_at >= ?', 3.days.ago) if params[:new_products] == '1'

    @products = @products.page(params[:page]).per(10)
  end

  def show
    @product = Product.find(params[:id])
  end
end
