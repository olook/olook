class SearchController < ApplicationController
  layout "lite_application"

  def show
   
    @s = SearchRedirectService.new(params[:q])
    redirect_to @s.path if @s.path
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: '/busca')
    search_params = @url_builder.parse_params
    @q = params[:q] || ""

    @singular_word = @q.singularize
    if catalogs_pages.include?(@singular_word)
      redirect_to catalog_path(category: @singular_word)
      return
    else
      @search = SearchEngine.new(term: @q,
        brand: search_params[:brand],
        subcategory: search_params[:subcategory],
        color: search_params[:color],
        heel: search_params[:heel])
          .for_page(params[:page])
          .with_limit(32)
      @url_builder.set_search @search
    end

    store_search_data_for_report

    @recommendation = RecommendationService.new(profiles: current_user.try(:profiles_with_fallback) || [Profile.default])
  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
  end

  private

  def catalogs_pages
    %w[roupa acessorio sapato bolsa]
  end

  def canonical_link
    "http://#{request.host_with_port}/busca"
  end

  def store_search_data_for_report
    if params[:cat] == 'search'
      searchboard = Searchboard.new
      searchboard.add(@q, @search.products.size)
    end

  end

end
