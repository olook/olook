# encoding: utf-8
module CustomUrlHelper

  def retrieve_filter custom_url
    case
    when /colecoes/ =~ custom_url.organic_url
      "collection_themes/menu"
    when /marcas/ =~ custom_url.organic_url
      "brands/side_filters"
    else
      category = [/bolsa/, /sapato/, /acessorio/, /roupa/].map{|a| custom_url.organic_url if a =~ custom_url.organic_url}.compact.first.gsub("/","")
      ["catalogs/filters", category]
    end
  end
end
