module BreadcrumbHelper
  def product_breadcrumbs_for(product, style_class="breadcrumb")
    content_tag(:ul, class: style_class) do
      BreadcrumbService.product_breadcrumbs_for(product).inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url]))
      end.concat(content_tag(:li,"#{product.formatted_name(500)}")).html_safe
    end
  end

  def first_level_breadcrumb(title, style_class="breadcrumb")
    content_tag(:ul, class: style_class) do
      [BreadcrumbService.home_url].inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url]))
      end.concat(content_tag(:li,title)).html_safe
    end    
  end

  def brand_breadcrumbs_for(brand, style_class="breadcrumb")
    content_tag(:ul, class: style_class) do
      BreadcrumbService.brand_breadcrumbs.inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url]))
      end.concat(content_tag(:li,"#{brand.name}")).html_safe
    end
  end

end
