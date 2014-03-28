# -*- encoding : utf-8 -*-
class ListProducts::SelectionsController < ListProductsController
  @url_prefix = "/selecoes"

  def index
    @path_positions =  '/selecoes/-:category::brand::subcategory:-/_:care::color::size::heel:-'
    visibility = "1-2-3"
    search_params = SeoUrl.parse(path: request.fullpath, path_positions: @path_positions).merge({visibility: visibility})
    default_params(search_params,"selections")
  end

  private

  def header
    @header ||= Header.for_url("/#{params[:lbl]}").first
  end


  def title_text
    "Seleções especiais | Roupas Femininas e Sapatos Femininos | Olook"
  end
end
