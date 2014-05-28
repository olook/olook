# -*- encoding : utf-8 -*-
class HeaderPresenter < BasePresenter

  #
  # We use the type name to link to the template, if you need to create a new
  # header, make sure to use a compatible name for your partial template, like:
  #
  # => NoBannerCatalogHeader -> _no_banner.html.haml
  # => BigBannerCatalogHeader -> _big_banner.html.haml
  #
  def show_header
    _header = header || OpenStruct.new({type: "NoBanner"})
    template_name =  _header.type.underscore.gsub("_catalog_header", "")
    h.render partial: "headers/#{template_name}", locals: {header: header}
  end
end
