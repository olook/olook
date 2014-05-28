# Set the host name for URL creation
#TODO
def sitemap_directory
  (Rails.env.test? || Rails.env.development?) ? 'testcdn.olook.com.br' : 'cdn.olook.com.br'
end
SitemapGenerator::Sitemap.default_host = "http://www.olook.com.br"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.filename = 'sitemap'
SitemapGenerator::Sitemap.create_index = false

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(Fog.credentials.merge({:fog_provider => "AWS", :fog_directory => sitemap_directory}))

SitemapGenerator::Sitemap.create do

  #CATALOG
  ["sapato", "roupa", "acessorio", "bolsa","curves"].each do |category|
    add catalog_path(category)
  end

  #SHOE
  Product.only_visible.where(category: 1).includes(:details).map{|cat| cat.subcategory.try(:parameterize)}.uniq.compact.each do |sub|
    add catalog_path("sapato", sub)
  end

  #BAG
  Product.only_visible.where(category: 2).includes(:details).map{|cat| cat.subcategory.try(:parameterize)}.uniq.compact.each do |sub|
    add catalog_path("bolsa", sub)
  end

  #ACCESSORY
  Product.only_visible.where(category: 3).includes(:details).map{|cat| cat.subcategory.try(:parameterize)}.uniq.compact.each do |sub|
    add catalog_path("acessorio", sub)
  end

  #CLOTH
  Product.only_visible.where(category: [4,5]).includes(:details).map{|cat| cat.subcategory.try(:parameterize)}.uniq.compact.each do |sub|
    add catalog_path("roupa", sub)
  end

  #lingerie
  Product.only_visible.where(category: 6).includes(:details).map{|cat| cat.subcategory.try(:parameterize)}.uniq.compact.each do |sub|
    add catalog_path("roupa", "#{sub}-moda-praia")
  end

  #CURVES
  Product.only_visible.where(category: 7).includes(:details).map{|cat| cat.subcategory.try(:parameterize)}.uniq.compact.each do |sub|
    add catalog_path("curves", sub)
  end

  # BRANDS
  add new_brands_path
  Brand.all.each do |brand|
    add brand_path(brand.name.parameterize) if brand.name
  end

  #NEW COLLECTIONS
  add collection_themes_path
  CollectionTheme.active.all.each do |collection|
    add collection_theme_path(collection.name.parameterize) if collection.name
  end

  #PRODUCT
  Product.only_visible.includes(:details).each do |product|
    add product_seo_path(product.seo_path)
  end

  #LIST PRODUCTS
  add olooklet_path
  add newest_path

  #GIFT
    add gift_root_path

  #REGULAR URLS
  add wysquiz_path
  add search_path
  add terms_path
  add duvidasfrequentes_path
  add return_policy_path
  add privacy_path
  add delivery_time_path
  add contact_path
  add loyalty_path
  add olookmovel_path
  add troca_path
  add press_path
  add "/stylist_news"

  #Good urls for seo
  SeoLink.each do |seo_link|
    add seo_link.path unless seo_link.try(:path).blank?
  end

end
