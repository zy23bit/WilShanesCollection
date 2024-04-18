ActiveAdmin.register Order do
  permit_params :user_id, :total_with_tax, :status,:shipping_address_id,:tax

  index do
    selectable_column
    id_column
    column :user
    column :tax
    column :total_with_tax
    column :status
    column :shipping_address_id
    actions
  end

  filter :user
  filter :status

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.all.collect { |user| [user.username, user.id] }
      f.input :total_with_tax
      f.input :status, as: :select, collection: Order.statuses.keys.map { |status| [status.humanize, status] }
      f.input :shipping_address_id, as: :select, collection: Address.where(user_id: f.object.user_id || User.first.id).collect { |address| [address.full_address, address.id] }
    end
    f.actions
  end
end
