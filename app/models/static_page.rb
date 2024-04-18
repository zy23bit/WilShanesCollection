class StaticPage < ApplicationRecord

  def self.ransackable_associations(auth_object = nil)
    []  # No associations
  end

  def self.ransackable_attributes(auth_object = nil)
    super - ['id', 'created_at', 'updated_at']
  end
end
