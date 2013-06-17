# -*- encoding : utf-8 -*-
class CatalogsController < SearchController
  layout "lite_application"
  respond_to :html, :js

  def show
    @category = params[:category].parameterize.singularize if params[:category]
    @subcategory = params[:categoria] if params[:categoria]
    @color = params[:color] if params[:color]
    @filters = SearchEngine.new(category: @category).filters
    @search = SearchEngine.new(category: @category, subcategory: @subcategory, color: @color).for_page(params[:page]).with_limit(100)
    @catalog_products = @search.products
  end

end
