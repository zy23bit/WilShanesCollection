class RemovePictureColumnsFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :product_picture, :string
    remove_column :products, :commercial_picture, :string
  end
end
