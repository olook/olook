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
  end

end
