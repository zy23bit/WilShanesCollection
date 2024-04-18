class AddTaxToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :tax, :decimal, precision: 10, scale: 2
  end
end
