class Address < ApplicationRecord
  belongs_to :user

  def full_address
    "#{address}, #{city}, #{province}, #{zip}"
  end

  def self.ransackable_associations(auth_object = nil)
    ['user']  # Allows searching through the user association
  end

  def self.ransackable_attributes(auth_object = nil)
    super - ['id', 'created_at', 'updated_at']  # Exclude sensitive or unnecessary fields
  end
end
