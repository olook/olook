# Set the host name for URL creation
#TODO
def sitemap_directory
  (Rails.env.test? || Rails.env.development?) ? 'testcdn.olook.com.br' : 'cdn.olook.com.br'
end
SitemapGenerator::Sitemap.default_host = "http://www.olook.com.br"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(Fog.credentials.merge({:fog_provider => "AWS", :fog_directory => sitemap_directory}))
SitemapGenerator::Sitemap.sitemaps_host = "http://#{sitemap_directory}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do

  #REGULAR URLS
  add wysquiz_path
  add search_path
  add terms_path
  add duvidasfrequentes_path
  add return_policy_path
  add privacy_path
  add delivery_time_path
  add helena_linhares_path
  add contact_path
  add loyalty_path
  add olookmovel_path
  add troca_path
  add press_path
  add "/stylist_news"

  # BRANDS
  add new_brands_path
  Brand.all.each do |brand|
    add brand_path(brand.name)
  end

  #NEW COLLECTIONS
  add collection_themes_path
  CollectionTheme.active.all.each do |collection|
    add collection_theme_path(collection.name)
  end

  #NEWS
  add news_shoes_path
  add news_clothes_path
  add news_bags_path
  add news_accessories_path

  #PRODUCT
  Product.only_visible.each do |product|
    add product_seo_path(product.seo_path)
  end

  #CATALOG
  ["sapato", "roupa", "acessorio", "bolsa"].each do |category|
    add catalog_path(category)
  end

  #GIFT
    add gift_root_path

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
