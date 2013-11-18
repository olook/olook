# -*- encoding : utf-8 -*-
module BreadcrumbHelper
  def product_breadcrumbs_for(product, style_class="breadcrumb")
    content_tag(:ul, class: style_class) do
      [home_url,{name: product.category_humanize.titleize.pluralize, url: "/#{product.category_humanize.downcase}"}].inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url], onclick: track_event('Breadcrumb', "Product")))
      end.concat(content_tag(:li,"#{product.formatted_name(500)}")).html_safe
    end
  end

  def first_level_breadcrumb(title, style_class="breadcrumb")
    content_tag(:ul, class: style_class) do
      [home_url].inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url], onclick: track_event('Breadcrumb', "#{params[:controller]}-#{params[:action]}")))
      end.concat(content_tag(:li,title)).html_safe
    end    
  end

  def brand_breadcrumbs_for(brand, style_class="breadcrumb")
    content_tag(:ul, class: style_class) do
      [home_url,{name: "Marcas", url: "/marcas"}].inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url], onclick: track_event('Breadcrumb', "Brand")))
      end.concat(content_tag(:li,"#{brand.name}")).html_safe
    end
  end

  def collection_theme_breadcrumbs_for(collection_theme, style_class="breadcrumb")
    content_tag(:ul, class: style_class) do
      [home_url,{name: "Coleções", url: "/colecoes"}].inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url], onclick: track_event('Breadcrumb', "CollectionTheme")))
      end.concat(content_tag(:li,"#{collection_theme.name}")).html_safe
    end
  end  

  def gift_breadcrumbs_for(style, style_class="breadcrumb")
    content_tag(:ul, class: style_class) do
      [home_url,{name: "Presentes", url: "/presentes"}].inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url], onclick: track_event('Breadcrumb', "Gift")))
      end.concat(content_tag(:li,style)).html_safe
    end
  end

  def olooklet_breadcrumbs_for(title, style_class="breadcrumb")
    content_tag(:ul, class: style_class) do
      [home_url,{name: "Olooklet", url: "/olooklet-teste"}].inject("") do |whole, breadcrumb_hash|
        whole.concat content_tag(:li,link_to("#{breadcrumb_hash[:name]}",breadcrumb_hash[:url], onclick: track_event('Breadcrumb', "Olooklet")))
      end.concat(content_tag(:li,title)).html_safe
    end    
  end  

  private

  def home_url
    {name: "Home", url: "/"}
  end

end
