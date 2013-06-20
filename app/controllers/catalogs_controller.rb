# -*- encoding : utf-8 -*-
class CatalogsController < SearchController
  layout "lite_application"
  respond_to :html, :js

  def show
    @category = params[:category].parameterize.singularize if params[:category]
    @subcategories = params[:subcategories] if params[:subcategories]
    @color = params[:color] if params[:color]
    @heel = params[:salto] if params[:salto]
    @care = params[:care] if params[:care]
    @brand = params[:brand] if params[:brand]
    @filters = SearchEngine.new(category: @category).filters
    @filters.grouped_products('categoria').delete_if{|c| Product::CARE_PRODUCTS.include?(c) }
    @search = SearchEngine.new(category: @category, subcategories: @subcategories, color: @color, heel: @heel, care: @care, brand: @brand, price: params[:preco]).for_page(params[:page]).with_limit(100)
    @catalog_products = @search.products

    # TODO => Mover para outro lugar
    whitelist = ["salto", "category", "color", "categoria"]
    @querystring = params.select{|k,v| whitelist.include?(k) }.to_query
  end

end
