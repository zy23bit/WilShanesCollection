class HomeController < ApplicationController
  def index
    @featured_products = Product.where(featured: true).limit(6)
    @random_video_product = Product.joins(:video_attachment).order('RANDOM()').first
  end
end
