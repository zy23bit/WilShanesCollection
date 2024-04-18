ActiveAdmin.register StaticPage do
  permit_params :title, :content, :identifier

  index do
    selectable_column
    id_column
    column :title
    column :identifier
    actions
  end

  filter :title
  filter :identifier

  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :text
      f.input :identifier
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :content
      row :identifier
    end
    active_admin_comments
  end
end
