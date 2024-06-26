class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def new
    @user_addresses = current_user.addresses
    @cart_items = @cart.cart_items
    @subtotal = @cart_items.sum do |item|
      if item.product.onSale
        item.quantity * item.product.sales_price
      else
        item.quantity * item.product.price
      end
    end
    @selected_address = current_user.addresses.first

    Rails.logger.debug "Selected Address: #{@selected_address}"
    Rails.logger.debug "Cart Subtotal: #{@subtotal}"

    if @selected_address
      @tax = calculate_tax(@subtotal, @selected_address.province)
      @total = @subtotal + @tax
    else
      @tax = 0
      @total = @subtotal
    end

    Rails.logger.debug "Calculated Tax: #{@tax}"
    Rails.logger.debug "Total Amount: #{@total}"
  end

  def calculate_tax_endpoint
    address = current_user.addresses.find_by(id: params[:address_id])
    Rails.logger.debug "Address for Tax Calculation: #{address}"

    if address
      subtotal = @cart.cart_items.sum do |item|
        if item.product.onSale
          item.quantity * item.product.sales_price
        else
          item.quantity * item.product.price
        end
      end
      tax = calculate_tax(subtotal, address.province)
      total = subtotal + tax
      Rails.logger.debug "Response Tax: #{tax}, Total: #{total}"
      session[:tax] = tax
      session[:total] = total
      session[:address] = address
      render json: { tax: view_context.number_to_currency(tax), total: view_context.number_to_currency(total), province: address.province }
    else
      render json: { error: 'Address not found' }, status: :not_found
    end
  end

  def create
    Rails.logger.debug "Stripe Token Received: #{params[:stripeToken]}"
    @tax = session[:tax]
    @total = session[:total]
    @address = params[:payment][:address_id]
    token = params[:stripe_token]

    begin
      ActiveRecord::Base.transaction do
        Rails.logger.debug "Creating order with Total with Tax: #{@total}, Tax: #{@tax}, Shipping Address ID: #{params[:payment][:address_id]}"

        @order = current_user.orders.create!(
          total_with_tax: @total,
          tax: @tax,
          status: :pending,
          shipping_address_id: params[:payment][:address_id]
        )

        Rails.logger.debug "Order created successfully: #{@order.inspect}"

        raise "Cart items are empty" if @cart.cart_items.empty?

        @cart.cart_items.each do |item|
          @order.order_items.create!(
            product_id: item.product_id,
            quantity: item.quantity,
            price_at_time: item.product.onSale ? item.product.sales_price : item.product.price
          )
        end

        Rails.logger.debug "Attempting to charge the customer with Stripe"
        charge = Stripe::Charge.create(
          amount: (@order.total_with_tax * 100).to_i, # amount in cents
          currency: 'cad',
          description: 'Product purchase',
          source: params[:stripeToken]
        )

        Rails.logger.debug "Stripe Charge Response: #{charge.inspect}"

        if charge.paid
          @order.update(status: :paid)
          @cart.destroy  # Clear the cart after order is placed
          redirect_to order_path(@order), notice: "Your order has been placed successfully."
        else
          raise Stripe::CardError.new("Card was declined.")
        end
      end
    rescue Stripe::CardError => e
      Rails.logger.error "Stripe Card Error: #{e.message}"
      redirect_to new_payment_path, alert: "Payment failed: #{e.message}"
    rescue => e
      Rails.logger.error "General Error during payment: #{e.message}"
      redirect_to new_payment_path, alert: "Failed to create order: #{e.message}"
    end
  end


  private

  def calculate_tax(subtotal, province_code)
    tax_rates = {
      'AB' => { gst: 0.05, pst: 0.00, hst: 0.00 },
      'BC' => { gst: 0.05, pst: 0.07, hst: 0.00 },
      'MB' => { gst: 0.05, pst: 0.07, hst: 0.00 },
      'NB' => { gst: 0.00, pst: 0.00, hst: 0.15 },
      'NL' => { gst: 0.00, pst: 0.00, hst: 0.15 },
      'NT' => { gst: 0.05, pst: 0.00, hst: 0.00 },
      'NS' => { gst: 0.00, pst: 0.00, hst: 0.15 },
      'NU' => { gst: 0.05, pst: 0.00, hst: 0.00 },
      'ON' => { gst: 0.00, pst: 0.00, hst: 0.13 },
      'PE' => { gst: 0.00, pst: 0.00, hst: 0.15 },
      'QC' => { gst: 0.05, pst: 0.09975, hst: 0.00 },
      'SK' => { gst: 0.05, pst: 0.06, hst: 0.00 },
      'YT' => { gst: 0.05, pst: 0.00, hst: 0.00 }
    }
    tax_info = tax_rates[province_code]
    gst = tax_info[:gst] * subtotal
    pst = tax_info[:pst] * subtotal
    hst = tax_info[:hst] * subtotal

    total_tax = gst + pst + hst

    total_tax
  end

  def set_cart
    @cart = current_cart
    Rails.logger.debug "Current Cart: #{@cart}"
  end

  def current_cart
    cart = Cart.find_or_create_by(user: current_user)
    Rails.logger.debug "Cart Found or Created: #{cart.id}"
    cart
  end
  def create_order
    @order = current_user.orders.create!(
      total_with_tax: @total,
      status: :pending,
      shipping_address_id: params[:address_id]
    )

    @cart.cart_items.each do |item|
      @order.order_items.create!(
        product_id: item.product.id,
        quantity: item.quantity,
        price_at_time: item.product.price
      )
    end
  end

  def clear_cart
    @cart.destroy
  end
  def order_params
    params.require(:payment).permit(:total_with_tax, :shipping_address_id)
  end
end