class AddSaleDetailsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :onSale, :boolean, default: false
    add_column :products, :discount, :integer
    add_column :products, :sales_price, :decimal
  end
end
