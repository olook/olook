class ShowroomPresenter
  CATEGORIES_FOR_SHOWROOM = [
    Category::CLOTH,
    Category::SHOE,
    Category::BAG,
    Category::ACCESSORY
  ]

  WHITELISTED_BRANDS = [
    "OLOOK ESSENTIAL",
    "Olook Concept",
    "Olook"
  ]

  def initialize(args={})
    @recommendation = args[:recommendation]
    @products_limit = args[:products_limit] || 22
    @looks_limit = args[:looks_limit] || 4
    @products = []
    @redis = Redis.connect(url: ENV['REDIS_CACHE_STORE'])
  end

  def products
    fetched_products = fetch_products_in_each_category
    organize_fetched_products_in_category_sequence(fetched_products)
    @products.first(@products_limit)
  end

  def looks(opts = {})
    @recommendation.full_looks({limit: @looks_limit, category: Category.without_curves, brand: WHITELISTED_BRANDS}.merge(opts))
  end

  def look(opts={})
    @look ||= looks({limit:1, brand: WHITELISTED_BRANDS}.merge(opts)).first
  end

  private

  def fetch_products_in_each_category
    categories_for_showroom.map do |category_id|
      @recommendation.products(category: category_id, limit: @products_limit)
    end.flatten
  end

  def organize_fetched_products_in_category_sequence(fetched_products)
    categories_for_showroom.cycle do |category_id|
      break if fetched_products.empty? || @products.size >= @products_limit
      p = fetched_products.find { |_p| _p.category == category_id }
      if p
        @products.push(p)
        fetched_products.delete(p)
      end
    end
  end

  def categories_for_showroom
    CATEGORIES_FOR_SHOWROOM
  end
end
