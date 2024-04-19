class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_one_attached :product_picture
  has_one_attached :commercial_picture
  has_one_attached :video


  def self.ransackable_associations(auth_object = nil)
    ['category', 'order_items']  # Allows searching through category and order_items associations
  end

  def self.ransackable_attributes(auth_object = nil)
    super - ['id', 'created_at', 'updated_at']
  end
end
