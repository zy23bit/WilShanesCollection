class AddNameToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :name, :string
  end
end
