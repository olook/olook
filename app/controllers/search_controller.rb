class SearchController < ApplicationController
  respond_to :html
  layout "lite_application"

  helper_method :parse_filters

  def show
    params.merge!(SeoUrl.parse(params))
    Rails.logger.debug("New params: #{params.inspect}")
    @q = params[:q] || ""

    @singular_word = @q.singularize
    if catalogs_pages.include?(@singular_word)
      redirect_to catalog_path(category: @singular_word)
    else

      @brand = params[:brand].humanize if params[:brand]
      @subcategory = params[:subcategory].parameterize if params[:subcategory]
      @search = SearchEngine.new(term: @q, brand: @brand, subcategory: @subcategory)
        .for_page(params[:page])
        .with_limit(48)
      @url_builder = SeoUrl.new(params, "term", @search)

      @model_names = {}

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
end
