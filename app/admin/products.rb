ActiveAdmin.register Product do
  permit_params :name, :description, :price, :category_id, :product_picture, :commercial_picture, :featured, :onSale, :discount, :sales_price, :video


  index do
    selectable_column
    id_column
    column :name
    column :price
    column :category
    column :featured
    column :onSale
    column :sales_price
    column :discount
    actions
  end

  filter :order_items_id
  filter :name
  filter :category
  filter :featured
  filter :onSale

  form do |f|
    f.semantic_errors
    f.inputs 'Product Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :featured
      f.input :category, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }
      f.input :product_picture, as: :file, hint: f.object.product_picture.attached? ? image_tag(url_for(f.object.product_picture)) : content_tag(:span, "No image yet")
      f.input :commercial_picture, as: :file, hint: f.object.commercial_picture.attached? ? image_tag(url_for(f.object.commercial_picture)) : content_tag(:span, "No image yet")
      f.input :video, as: :file, hint: f.object.video.present? ?
      video_tag(url_for(f.object.video), controls: true, size: "100x100") : content_tag(:span, "No video yet")
      f.input :onSale
      f.input :discount
      f.input :sales_price, input_html: { disabled: true }
    end
    f.actions
  end

  show do |product|
    attributes_table do
      row :name
      row :description
      row :price
      row :category
      row :featured
      row :onSale
      row :product_picture do |p|
        if p.product_picture.attached?
          image_tag url_for(p.product_picture)
        end
      end
      row :commercial_picture do |p|
        if p.commercial_picture.attached?
          image_tag url_for(p.commercial_picture)
        end
      end
    end
  end
  before_save do |product|
    if product.onSale && product.discount.present?
      product.sales_price = product.price - (product.price * (product.discount / 100.0))
    else
      product.sales_price = nil
    end
  end
end
