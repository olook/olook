# -*- encoding : utf-8 -*-
class ListProducts::SelectionsController < ListProductsController
  @url_prefix = "/selecoes"

  def index
    Rails.logger.debug(params)
    @path_positions =  '/selecoes/-:category::brand::subcategory:-/_:care::color::size::heel:-'
    @visibility = [1,2,3]
    default_params
    redirect_to selections_not_found_path if Rails.cache.fetch("#{@cache_key}count", expire: 90.minutes) { @search.products.size }.to_i == 0
    expire_fragment(@cache_key) if params[:force_cache].to_i == 1
  end

  def not_found
    @path_positions = '/olooklet/-:category::brand::subcategory:-/-:care::color::size::heel:_'
    default_params
  end

  private

  def header
    @header ||= Header.for_url("/#{params[:lbl]}").first
  end
end
