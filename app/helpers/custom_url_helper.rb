# encoding: utf-8
module CustomUrlHelper

  def retrieve_filter path
    case
    when /colecoes/ =~ path
      "collection_themes/menu"
    when /marcas/ =~ path
      "brands/side_filters"
    else
      category = [/bolsa/, /sapato/, /acessorio/, /roupa/].map{|a| path if a =~ path}.compact.first.gsub("/","")
      ["catalog/filters", category]
    end
  end
end
