class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    item = @cart.cart_items.find_by(product_id: product.id)

    if item
      item.quantity += 1
    else
      item = @cart.cart_items.new(product: product, quantity: 1)
    end

    if item.save
      redirect_to cart_path, notice: 'Product added to cart!'
    else
      redirect_to product_path(product), alert: 'Error adding product to cart.'
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_path, notice: 'Cart updated.'
    else
      render 'carts/show', alert: 'Failed to update cart item.'
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: 'Item removed from cart.'
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
  def current_cart
    Cart.find_or_create_by(user: current_user)
  end
end
