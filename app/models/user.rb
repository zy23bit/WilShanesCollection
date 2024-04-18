class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_one :cart, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :addresses, allow_destroy: true, reject_if: proc { |attributes| attributes['address'].blank? }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_associations(auth_object = nil)
    ['addresses', 'orders']  # Allows searching through addresses and orders associations
  end

  def self.ransackable_attributes(auth_object = nil)
    super - ['encrypted_password']  # Exclude sensitive attributes
  end
end
