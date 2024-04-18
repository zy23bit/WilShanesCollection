class Category < ApplicationRecord
  has_many :products

  def self.ransackable_associations(auth_object = nil)
    ['products']  # Allows searching through products association
  end

  def self.ransackable_attributes(auth_object = nil)
    super - ['id', 'created_at', 'updated_at']
  end
end
