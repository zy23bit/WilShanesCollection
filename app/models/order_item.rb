class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def self.ransackable_associations(auth_object = nil)
    ['order', 'product']  # Allows searching through order and product associations
  end

  def self.ransackable_attributes(auth_object = nil)
    super - ['id', 'created_at', 'updated_at']
  end
end
