# encoding: utf-8
module CustomUrlHelper
  def retrieve_filter custom_url
    case
    when /^\/?colecoes/ =~ custom_url.organic_url
      "collection_themes/menu"
    when /^\/?marcas/ =~ custom_url.organic_url
      "brands/side_filters"
    else
      "catalogs/filters"
    end
  end

  def load_stylesheet custom_url
    case
    when /^\/?colecoes/ =~ custom_url.organic_url
      stylesheet_link_tag "new_structure/section/collection_themes"
    when /^\/?marcas/ =~ custom_url.organic_url
      stylesheet_link_tag "new_structure/section/brands"
    else
      stylesheet_link_tag "new_structure/section/lite_catalog"
    end
  end
end
