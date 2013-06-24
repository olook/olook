# -*- encoding : utf-8 -*-
class CatalogsController < SearchController
  layout "lite_application"
  respond_to :html, :js

  def show
    params.merge!(SeoUrl.parse(params[:parameters], params))
    Rails.logger.debug("New params: #{params.inspect}")

    @filters = SearchEngine.new(category: params[:category]).filters
    @filters.grouped_products('subcategory').delete_if{|c| Product::CARE_PRODUCTS.include?(c) } if @filters.grouped_products('subcategory')

    @search = SearchEngine.new(category: params[:category],
                               subcategory: params[:subcategory],
                               color: params[:color],
                               heel: params[:heel],
                               care: params[:care],
                               size: params[:size],
                               brand: params[:brand]).for_page(params[:page]).with_limit(100)

    @catalog_products = @search.products
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])

    # TODO => Mover para outro lugar
    whitelist = ["salto", "category", "color", "categoria"]
    @querystring = params.select{|k,v| whitelist.include?(k) }.to_query
  end

end
