ActiveAdmin.register User do
  permit_params :username, :email

  index do
    selectable_column
    id_column
    column :username
    column :email
    column "Order Count" do |user|
      user.orders.count
    end
    actions
  end

  filter :username
  filter :email

  filter :orders_status, as: :select, collection: -> { Order.statuses.keys.map { |status| [status.titleize, status] } }

  form do |f|
    f.inputs do
      f.input :username
      f.input :email
    end
    f.actions
  end
end
