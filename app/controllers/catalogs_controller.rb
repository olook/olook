# -*- encoding : utf-8 -*-
class CatalogsController < SearchController
  layout "lite_application"
  respond_to :html, :js

  def show
    @category = params[:category].parameterize.singularize if params[:category]
    url = SearchUrlBuilder.new
      .with_category(@category)
      .grouping_by
      .build_url
    @result = fetch_products url
    @catalog_products = @result.products
    @products_id = @catalog_products.first(3).map{|item| item.id }.compact
    @collection_theme = CollectionTheme.find 1
  end

end
