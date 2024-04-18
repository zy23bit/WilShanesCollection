class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: [:show]
  def show
    @cart_items = @cart.cart_items
  end

  private

  def set_cart
    @cart = current_cart
  end

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = current_user.create_cart
    session[:cart_id] = cart.id
    cart
  end

  def add_to_cart
    product = Product.find(params[:product_id])
    item = @cart.cart_items.find_by(product_id: product.id)

    if item
      item.quantity += 1
    else
      item = @cart.cart_items.build(product: product, quantity: 1)
    end

    if item.save
      redirect_to cart_path, notice: 'Product added to cart!'
    else
      redirect_to product_path(product), alert: 'Failed to add product to cart.'
    end
  end
end