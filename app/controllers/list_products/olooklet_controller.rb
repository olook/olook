# -*- encoding : utf-8 -*-
class ListProducts::OlookletController < ListProductsController
  @url_prefix = '/olooklet'

  def index
    visibility = params[:visibility] || "#{Product::PRODUCT_VISIBILITY[:olooklet]}-#{Product::PRODUCT_VISIBILITY[:all]}"
    request_path = params[:path] || request.fullpath
    search_params = SeoUrl.parse(request_path).merge({visibility: visibility})
    default_params(search_params,"olooklet")
    @url_builder.set_link_builder { |_param| olooklet_path(_param) }
  end

  private

  def header
    @header ||= CatalogHeader::CatalogBase.for_url(request.path).first
    @header ||= CatalogHeader::CatalogBase.for_url(self.class.url_prefix).first
  end

  def title_text
    "Outlet Online | Roupas Femininas e Sapatos Femininos | Olook"
  end

end
