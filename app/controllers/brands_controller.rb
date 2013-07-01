class BrandsController < ApplicationController
  layout "lite_application"
  def index
  end

  def show
    params.merge!(SeoUrl.parse_brands(params[:parameters], params))
    Rails.logger.debug("New params: #{params.inspect}")

    @search = SearchEngine.new(category: params[:category],
                               care: params[:care],
                               subcategory: params[:subcategory],
                               color: params[:color],
                               heel: params[:heel],
                               care: params[:care],
                               price: params[:price],
                               size: params[:size],
                               brand: params[:brand],
                               sort: params[:sort]).for_page(params[:page]).with_limit(48)
    @search.for_admin if current_admin
    @catalog_products = @search.products
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
  end
end
