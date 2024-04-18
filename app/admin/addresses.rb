ActiveAdmin.register Address do
  permit_params :user_id, :address, :city, :province, :zip, :name

  filter :user_email

  index do
    selectable_column
    id_column
    column :user
    column :name
    column :address
    column :city
    column :province
    column :zip
    actions
  end

  filter :user
  filter :city
  filter :province
  filter :zip
  filter :name

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.all.collect { |user| [user.username, user.id] }
      f.input :name
      f.input :address
      f.input :city
      f.input :province
      f.input :zip
    end
    f.actions
  end
end
