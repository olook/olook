module CatalogsHelper
  def filter_link_to(link, text, selected=false, amount=nil)
    span_class = text.downcase
    search_param = params[:q].blank? ? "" : "?q=#{params[:q]}"
    text += " (#{amount})" if amount
    class_hash = selected ? {class: "selected"} : {}
    link+=search_param
    link_to(link, class_hash) do
      content_tag(:span, text, class:"txt-#{span_class}")
    end
  end

  def filters_by filter
    @filters.grouped_products(filter)
  end

end
