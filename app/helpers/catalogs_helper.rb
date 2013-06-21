module CatalogsHelper
  def filter_link_to(link, text, selected=false, amount=nil)
    span_class = text.downcase
    text += " (#{amount})" if amount
    class_hash = selected ? {class: "selected"} : {}
    link_to(link, class_hash) do
      content_tag(:span, text, class:"txt-#{span_class}")
    end
  end

  def filters_by filter
    @filters.grouped_products(filter)
  end

end
