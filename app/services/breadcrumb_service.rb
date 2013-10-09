class BreadcrumbService
  def self.product_breadcrumbs_for product
    [home_url,{name: product.category_humanize.titleize.pluralize, url: "/#{product.category_humanize.downcase}"}]
  end
  
  def self.home_url
    {name: "Home", url: "/"}
  end
end