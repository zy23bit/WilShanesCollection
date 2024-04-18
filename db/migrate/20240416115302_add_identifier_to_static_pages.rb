class AddIdentifierToStaticPages < ActiveRecord::Migration[7.1]
  def change
    add_column :static_pages, :identifier, :string
    add_index :static_pages, :identifier, unique: true
  end
end
