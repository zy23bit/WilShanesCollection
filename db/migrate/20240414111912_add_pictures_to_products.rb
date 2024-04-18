class AddPicturesToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :product_picture, :string
    add_column :products, :commercial_picture, :string
  end
end
