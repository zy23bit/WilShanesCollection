class HomeController < ApplicationController
  def index
    @featured_products = Product.where(featured: true).limit(6)
  end
end
