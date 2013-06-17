# -*- encoding : utf-8 -*-
class CatalogsController < SearchController
  layout "lite_application"
  respond_to :html, :js

  def show
    @category = params[:category].parameterize.singularize if params[:category]
    @subcategory = params[:categoria] if params[:categoria]


    filter_url = SearchUrlBuilder.new
      .with_category(@category)
      .grouping_by
      .build_filters_url
    @filters = fetch_products(filter_url, parse_facets: true)


    @current_page = params[:page].present? ? params[:page].to_i : 1
    @next_page = (@current_page + 1).to_s
    @previous_page = (@current_page - 1).to_s

      url = SearchUrlBuilder.new
      .with_category(@category)
      .with_subcategory(@subcategory)
      .grouping_by
      .with_limit(100)
      .for_page(@current_page)
      .build_url

    @result = fetch_products(url, {parse_products: true})

    @pages = (@result.hits["found"] / 100.0).ceil
  end

end
