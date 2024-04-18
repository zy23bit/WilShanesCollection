class AddShippingAddressToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :shipping_address_id, :bigint
    add_foreign_key :orders, :addresses, column: :shipping_address_id
  end
end
