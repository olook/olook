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
    @category = params[:category].parameterize if params[:category]

    url = SearchUrlBuilder.new
      .for_term(@q)
      .with_model_name(@category)
      .with_brand(@brand)
      .with_color(@color)
      .grouping_by
      .build_url

    # .build_url_with({category: params[:category], brand: params[:brand], rank: "cor_e_marca"})
    @result = fetch_products url

    @stylist = Product.fetch_products :selection
  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
  end

  private

    def fetch_products url
      response = Net::HTTP.get_response(url)
      SearchResult.new response
    end


end
