class SearchController < ApplicationController
  respond_to :html
  layout "lite_application"

  def index
    url = SearchUrlBuilder.new
      .for_term("a*").grouping_by.build_url
    @result = fetch_products url
    render :show
  end

  def show
    @q = params[:q]
    @brand = params[:brand].humanize if params[:brand]
    @color = params[:color]
    @subcategory = params[:category].parameterize if params[:category]

    @search = SearchEngine.new(term: @q, brand: @brand, subcategory: @subcategory, color: @color).for_page(params[:page])
    @products = @search.products

    @filters = SearchEngine.new(term: @q, brand: @brand, subcategory: @subcategory, color: @color).filters
    @filters.grouped_products('subcategory').delete_if{|c| Product::CARE_PRODUCTS.include?(c) }
    @stylist = Product.fetch_products :selection
  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
  end

  private

    def fetch_products(url, options = {})
      response = Net::HTTP.get_response(url)
      SearchResult.new(response, options)
    end


end
