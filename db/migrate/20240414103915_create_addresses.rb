class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.text :address
      t.string :city
      t.string :province
      t.string :zip

      t.timestamps

      t.index :zip, unique: true
    end
  end
end
