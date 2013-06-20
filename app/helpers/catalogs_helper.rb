module CatalogsHelper
  def filter_link_to(link, text, amount=nil)
    span_class = text.downcase
    text += " (#{amount})" if amount
    link_to link do
      content_tag(:span, text, class:"txt-#{span_class}")
    end
  end

  def filters_by filter
    @filters.grouped_products(filter)
  end
end
