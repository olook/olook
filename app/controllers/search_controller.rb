class SearchController < ApplicationController
  layout "lite_application"

  def show
    params.merge!(SeoUrl.parse(params))
    Rails.logger.debug("New params: #{params.inspect}")
    @q = params[:q] || ""

    @singular_word = @q.singularize
    if catalogs_pages.include?(@singular_word)
      redirect_to catalog_path(category: @singular_word)
    else
      @search = SearchEngine.new(term: @q, brand: params[:brand], subcategory: params[:subcategory])
        .for_page(params[:page])
        .with_limit(48)
      @url_builder = SeoUrl.new(params, nil, @search)
    end

  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
  end

  private
    def catalogs_pages
      %w[roupa acessorio sapato bolsa]
    end
end
