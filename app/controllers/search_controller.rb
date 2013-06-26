class SearchController < ApplicationController
  respond_to :html
  layout "lite_application"

  def show
    params.merge!(SeoUrl.parse(params[:parameters], search: true))
    Rails.logger.debug("New params: #{params.inspect}")
    @q = params[:q] || ""

    @singular_word = @q.singularize
    if catalogs_pages.include?(@singular_word)
      redirect_to catalog_path(parameters: @singular_word)
    else

      @brand = params[:brand].humanize if params[:brand]
      @subcategory = params[:subcategory].parameterize if params[:subcategory]

      @search = SearchEngine.new(term: @q, brand: @brand, subcategory: @subcategory).for_page(params[:page]).with_limit(48)
      @products = @search.products

      @model_names = {}

      @filters = parse_filters

      @stylist = Product.fetch_products :selection

    end

  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
  end

  private

    def fetch_products(url, options = {})
      response = Net::HTTP.get_response(url)
      SearchResult.new(response, options)
    end

    def catalogs_pages
      %w[roupa acessorio sapato bolsa]
    end

    def parse_filters
      category_tree = SeoUrl.all_categories

      filters = SearchEngine.new(term: @q, brand: @brand, subcategory: @subcategory, color: @color).filters

      return nil unless filters.grouped_products('subcategory')

      filters.grouped_products('subcategory').delete_if{|c| Product::CARE_PRODUCTS.include?(c) }

      category_tree.each{|k,v| v.delete_if{|subcategory| !filters.grouped_products('subcategory').include?(subcategory)} }

      category_tree["Marcas"] = filters.grouped_products('brand_facet').keys

      category_tree
    end


end
