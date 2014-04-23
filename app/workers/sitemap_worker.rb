class SitemapWorker
  @queue = 'low'

  def self.perform
    sitemap = {
      brands: Product.only_visible.joins(:variants).where("variants.inventory >= 1").pluck(:brand).uniq.compact.reject! { |c| c.empty? },
      collection_themes: CollectionTheme.active.all.map{|a| [a.name, a.slug]},
      shoes: Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 1, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq,
      accessories: Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 3, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq,
      bags: Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 2, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq,
      cloths: Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 4, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq
    }
    redis.set("sitemap", sitemap.to_json)
  end

  def self.redis
    Redis.connect(url: ENV['REDIS_SITEMAP'])
  end
end

