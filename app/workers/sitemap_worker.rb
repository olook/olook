class SitemapWorker
  @queue = 'low'

  def self.perform
    sitemap = {
      brands: self.brands,
      collection_themes: self.collection_themes,
      shoes: self.subcategories_for(Category::SHOE),
      accessories: self.subcategories_for(Category::ACCESSORY),
      bags: self.subcategories_for(Category::BAG),
      cloths: self.subcategories_for(Category::CLOTH)
    }
    redis.set("sitemap", sitemap.to_json)
  end

  def self.redis
    Redis.connect(url: ENV['REDIS_SITEMAP'])
  end

  def self.collection_themes
    CollectionTheme.active.all.
      map{|a| [a.name, a.slug]}
  end

  def self.brands
    Product.only_visible.joins(:variants).
      where("variants.inventory >= 1").
      pluck(:brand).uniq.compact.
      reject { |c| c.empty? }
  end

  def self.subcategories_for(category_id)
    Detail.where(translation_token: 'Categoria').joins(:product).
      where(products: {category: category_id, is_visible: true}).
      pluck(:description).map {|b| b.parameterize}.uniq
  end
end

