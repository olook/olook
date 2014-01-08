# -*- encoding : utf-8 -*-
class ListProducts::NewestProductsController < ListProductsController
  @url_prefix = '/novidades'
  PRODUCTS_SIZE = 42

  def index
    visibility = "#{Product::PRODUCT_VISIBILITY[:site]}-#{Product::PRODUCT_VISIBILITY[:all]}"
    search_params = SeoUrl.parse(request.fullpath).merge({visibility: visibility})

    default_params(search_params, "novidades")

    @url_builder.set_link_builder { |_param| newest_path(_param) }
    @search.sort = 'age'
    @search.with_limit(PRODUCTS_SIZE)
    @search.for_page(1)
  end

  private
  def header
    @header ||= CatalogHeader::CatalogBase.for_url(request.path).first
    @header ||= CatalogHeader::CatalogBase.for_url(self.class.url_prefix).first
  end

  def title_text
    "Novidades | Roupas Femininas e Sapatos Femininos | Olook"
  end
end
