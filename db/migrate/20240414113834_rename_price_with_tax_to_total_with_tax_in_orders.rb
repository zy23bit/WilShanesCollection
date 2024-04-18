class RenamePriceWithTaxToTotalWithTaxInOrders < ActiveRecord::Migration[7.1]
  def change
    rename_column :orders, :price_with_tax, :total_with_tax
  end
end
