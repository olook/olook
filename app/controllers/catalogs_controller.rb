# -*- encoding : utf-8 -*-
class CatalogsController < SearchController
  layout "lite_application"
  respond_to :html, :js

  def show
    params.merge!(SeoUrl.parse(params[:parameters], params))
    Rails.logger.debug("New params: #{params.inspect}")

    @filters = create_filters

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
