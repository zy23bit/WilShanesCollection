class RemovePasswordDigestFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :encrypted_password, :string
  end
end
