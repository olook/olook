# -*- encoding : utf-8 -*-
class CatalogsController < SearchController
  layout "lite_application"
  respond_to :html, :js

  def show
    @category = params[:category].parameterize.singularize if params[:category]
    @subcategory = params[:categoria] if params[:categoria]
    @color = params[:color] if params[:color]

    filter_url = SearchUrlBuilder.new
      .with_category(@category)
      .grouping_by
      .build_filters_url
    @filters = fetch_products(filter_url, parse_facets: true)



    url = SearchUrlBuilder.new
      .with_category(@category)
      .with_subcategory(@subcategory)
      .with_color(@color)
      .grouping_by
      .build_url

    @result = fetch_products(url, {parse_products: true})
    @catalog_products = @result.products
  end

end
