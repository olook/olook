# -*- encoding : utf-8 -*-
module BreadcrumbHelper
  def first_level_breadcrumb(title, style_class="breadcrumb")
    generate_breadcrumb([home_url],"#{params[:controller]}-#{params[:action]}", title, style_class)
  end

  def product_breadcrumbs_for(product, style_class="breadcrumb")
    second_level_breadcrumb(product.category_humanize.titleize.pluralize, "/#{product.category_humanize.downcase}", "Product",product.formatted_name(200), style_class)
  end  

  def brand_breadcrumbs_for(brand, style_class="breadcrumb")
    second_level_breadcrumb("Marcas", "/marcas", "Brand", brand.name, style_class)
  end

  def collection_theme_breadcrumbs_for(collection_theme, style_class="breadcrumb")
    second_level_breadcrumb("Coleções", "/colecoes", "CollectionTheme",collection_theme.name, style_class)
  end  

  def gift_breadcrumbs_for(style, style_class="breadcrumb")
    second_level_breadcrumb("Presentes", "/presentes", "Gift", style, style_class)
  end

  def olooklet_breadcrumbs_for(title, style_class="breadcrumb")
    second_level_breadcrumb("Olooklet", "/olooklet-teste", "Olooklet", title, style_class)
  end  

  private

  def home_url
    {name: "Home", url: "/"}
  end

  def second_level_breadcrumb(second_level_name, second_level_url, event_name, title, style_class)
    generate_breadcrumb([home_url,{name: second_level_name, url: second_level_url}],event_name, title, style_class)
  end

  def generate_breadcrumb(breadcrumb_array, event_name, title, style_class)
    content_tag(:ul, class: style_class) do
      breadcrumb_array.inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url], onclick: track_event('Breadcrumb', event_name)))
      end.concat(content_tag(:li,title)).html_safe
    end        
  end  

end
