class OrdersController < ApplicationController
  before_action :set_order, only: [:show]

  def show
    redirect_to root_path, alert: "Not authorized" unless @order.user_id == current_user.id
  end
  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Order not found.'
  end
end
