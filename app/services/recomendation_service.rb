class RecomendationService

  def initialize(opts = {})
    #@collection = Collection.current
    @profiles = opts[:profiles]
    @shoe_size = opts[:shoe_size]
  end

  def products(opts= {  })

    current_limit = limit = opts[:limit] || 5
    category = opts[:category]
    products = []

    @profiles.each do |profile|
      products_arel = profile.products.includes(:variants).group(Product.arel_table[:id]).where(Variant.arel_table[:inventory].gt 0)

      products_arel = products_arel.joins(:variants).where(Product.arel_table[:category].not_eq(Category::SHOE).or(Product.arel_table[:category].eq(Category::SHOE).and(Variant.arel_table[:description].eq(@shoe_size)))) if @shoe_size.present?


      products_arel = products_arel.where(category: category) if category.present?
      products += products_arel.first(current_limit).sort { |a,b| b.inventory <=> a.inventory }
      current_limit = limit - products.size
      break if products.size == limit
    end
    products
  end

end
