class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  belongs_to :shipping_address, class_name: 'Address', foreign_key: 'shipping_address_id', optional: true

  validates :shipping_address_id, presence: true

  enum status: { pending: 0, confirmed: 1, shipped: 2, delivered: 3, cancelled: 4 }

  def self.ransackable_associations(auth_object = nil)
    ['user', 'order_items']  # Allows searching through user and order_items associations
  end

  def self.ransackable_attributes(auth_object = nil)
    super - ['id', 'created_at', 'updated_at']
  end
end
