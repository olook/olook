class RecomendationService

  def initialize(opts = {})
    @profiles = opts[:profiles]
    @shoe_size = opts[:shoe_size]
  end

  # Produtos recomendados para os parametros passados na
  #
  #
  def products(opts= {  })
    current_limit = limit = opts[:limit] || 5
    products = []

    @profiles.each do |profile|
      products += filtered_list_for_profile(profile, opts).first(current_limit).sort { |a,b| b.inventory <=> a.inventory }
      current_limit = limit - products.size
      break if products.size == limit
    end
    products.uniq
  end

  private
    def filtered_list_for_profile(profile, opts={})
      _pAt = Product.arel_table
      _vAt = Variant.arel_table

      is_admin = opts[:admin] || false
      category = opts[:category]
      collection = opts[:collection]

      response = if is_admin
        profile.products.group('products.name').includes(:variants, :pictures)
      else
        profile.products.only_visible.group('products.name').includes(:variants, :pictures).
          where(_vAt[:inventory].gt(0).and(_vAt[:price].gt(0)))
      end

      response = response.
        where(_pAt[:collection_id].eq(collection.id)) if collection

      response = response.joins(:variants).
        where(_pAt[:category].not_eq(Category::SHOE).
            or(_pAt[:category].eq(Category::SHOE).
                and(_vAt[:description].eq(@shoe_size))
              )) if @shoe_size.present?

      response = response.where(category: category) if category.present?    

      response
    end

end
