class RecomendationService

  def initialize(opts = {})
    #@collection = Collection.current
    @profile = opts[:profile]
  end

  def products(opts= {  })
    limit = opts[:limit] || 5
    category = opts[:category]
    products_arel = @profile.products
    products_arel = products_arel.where(category: category) if category.present?
    products_arel.first(limit)
  end
end
