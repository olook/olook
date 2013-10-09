module BreadcrumbHelper
  def product_breadcrumbs_for product
    content_tag(:ul) do
      BreadcrumbService.product_breadcrumbs_for(product).inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url]))
      end.concat(content_tag(:li,"#{product.formatted_name(500)}")).html_safe
    end
  end
end
