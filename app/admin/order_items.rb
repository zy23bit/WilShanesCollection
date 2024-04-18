ActiveAdmin.register OrderItem do
  permit_params :order_id, :product_id, :quantity, :price_at_time

  index do
    selectable_column
    id_column
    column :order
    column :product
    column :quantity
    column :price_at_time
    actions
  end

  filter :order
  filter :product

  form do |f|
    f.inputs do
      f.input :order, as: :select, collection: Order.all.collect { |order| [order.id, order.id] }
      f.input :product, as: :select, collection: Product.all.collect { |product| [product.name, product.id] }
      f.input :quantity
      f.input :price_at_time
    end
    f.actions
  end
end
