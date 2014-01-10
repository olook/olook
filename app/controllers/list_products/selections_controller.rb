# -*- encoding : utf-8 -*-
class ListProducts::SelectionsController < ListProductsController
  @url_prefix = "/selecoes"

  def index
    visibility = "1-2-3"
    search_params = SeoUrl.parse(request.fullpath).merge({visibility: visibility})
    default_params(search_params,"selections")
    @url_builder.set_link_builder { |_param| selections_path(_param) }
  end

  private

  def header
    @header ||= CatalogHeader::CatalogBase.for_url("/#{params[:lbl]}").first
  end


  def title_text
    "Seleções especiais | Roupas Femininas e Sapatos Femininos | Olook"
  end
end
