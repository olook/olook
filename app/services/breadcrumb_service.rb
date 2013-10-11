# -*- encoding : utf-8 -*-
class BreadcrumbService
  def self.product_breadcrumbs_for product
    [home_url,{name: product.category_humanize.titleize.pluralize, url: "/#{product.category_humanize.downcase}"}]
  end
  
  def self.home_url
    {name: "Home", url: "/"}
  end

  def self.brand_breadcrumbs
    [home_url,{name: "Marcas", url: "/marcas"}]
  end

  def self.collection_theme_breadcrumbs
    [home_url,{name: "Coleções", url: "/colecoes"}]
  end      

  def self.gift_breadcrumbs
    [home_url,{name: "Presentes", url: "/presentes"}]
  end  
end