class StaticPagesController < ApplicationController
  def show
    @static_page = StaticPage.find_by!(identifier: params[:identifier])
  end
end
