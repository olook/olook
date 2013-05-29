class RecomendationService

  def initialize(opts = {})
    @profiles = opts[:profiles]
    @shoe_size = opts[:shoe_size]
  end

  # Produtos recomendados para os parametros passados na
  #
  #
  def products(opts= {  })
    _pAt = Product.arel_table
    _vAt = Variant.arel_table

    is_admin = opts[:admin] || false
    current_limit = limit = opts[:limit] || 5
    category = opts[:category]
    collection = opts[:collection]
    products = []

    @profiles.each do |profile|

      if is_admin
        products_arel = profile.products.group('products.name').includes(:variants)
      else
        products_arel = profile.products.only_visible.group('products.name').includes(:variants).
          where(_vAt[:inventory].gt(0).and(_vAt[:price].gt(0)))
      end

      products_arel = products_arel.
        where(_pAt[:collection_id].eq(collection.id)) if collection

     products_arel = products_arel.joins(:variants).
       where(_pAt[:category].not_eq(Category::SHOE).
             or(_pAt[:category].eq(Category::SHOE).
                and(_vAt[:description].eq(@shoe_size))
               )) if @shoe_size.present?

      products_arel = products_arel.where(category: category) if category.present?
      products += products_arel.first(current_limit).sort { |a,b| b.inventory <=> a.inventory }
      current_limit = limit - products.size
      break if products.size == limit
    end
    products
  end

end
