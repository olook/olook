class RecommendationService

  DAYS_AGO_TO_CONSIDER_NEW = 200
  DAYS_AGO_TO_CONSIDER_NEW_PRODUCTS = 30
  DATE_WHEN_PICTURES_CHANGED = "2013-07-01"
  WHITELISTED_SUBCATEGORIES = [
    'blazer',
    'blusa',
    'camisa',
    'camiseta',
    'casaco',
    'casaco e jaqueta',
    'colete',
    'macacao',
    'regata',
    'top cropped',
    'vestido'
  ]

  def profile_name
    @profiles.first.try(:alternative_name) || "casual"
  end

  def initialize(opts = {})
    @profiles = opts[:profiles]
    @shoe_size = opts[:shoe_size]
  end

  # Produtos recomendados para os parametros passados na
  #
  #
  def products(opts= {})
    current_limit = limit = opts[:limit] || 10
    products = []

    @profiles.each do |profile|
      products += filtered_list_for_profile(profile, opts).first(current_limit)
      current_limit = limit - products.size
      break if products.size == limit
    end
    products.uniq
  end

  def full_looks(opts={})
    current_limit = limit = opts[:limit] || 10
    if opts[:hot_products]

      product_ids = WHITELISTED_SUBCATEGORIES.inject([]) do |arr, s|
        arr + Leaderboard.new(key: "roupa:#{s.parameterize}").rank(limit * 10, with_scores: true)
      end.sort { |a,b| b.last <=> a.last }.first(limit * 15)
      if product_ids.size >= limit
        opts[:product_ids] = product_ids.map { |pid, count| pid }
      else
        opts[:hot_products] = false
      end
    end

    looks = []
    @profiles.each do |profile|
      opts[:profile] = profile
      looks += filtered_looks_for_profile(opts).first(current_limit)
      current_limit = limit - looks.size
      break if looks.size >= limit
    end
    looks.uniq!

    if opts[:hot_products]
      looks = looks.inject({}) { |h, l| h[l.id.to_s] = l; h }
      looks = product_ids.map { |pid, count| looks[pid.to_s] }.compact.first(opts[:limit])
    end
    looks
  end

  private

  def filtered_looks_for_profile(opts={})
    _pAt = Product.arel_table
    _vAt = Variant.arel_table
    _dAt = Detail.arel_table

    if opts[:profile]
      result = opts[:profile].products
    else
      result = Product
    end
    result = result.where(_pAt[:launch_date].gt(DAYS_AGO_TO_CONSIDER_NEW.days.ago))
    .where(_pAt[:created_at].gt(DATE_WHEN_PICTURES_CHANGED))
    .includes(:variants, :pictures)

    result = result.where(_pAt[:brand].in(opts[:brand])) if opts[:brand]

    result = result.joins(:details).where(_dAt[:translation_token].eq('categoria').and(_dAt[:description].in(WHITELISTED_SUBCATEGORIES)))

    result = result.only_visible.where(_vAt[:inventory].gt(0).and(_vAt[:price].gt(0))) unless opts.fetch(:admin, false)
    result = result.where(_pAt[:id].in(opts[:product_ids])) if opts[:product_ids]
    result.group(_pAt[:id])

    result
  end

  def filtered_list_for_profile(profile, opts={})
    return [] unless profile
    _pAt = Product.arel_table
    _vAt = Variant.arel_table

    is_admin = opts.fetch(:admin, false)
    category = opts[:category]

    result = profile.products.where(_pAt[:launch_date].gt(DAYS_AGO_TO_CONSIDER_NEW_PRODUCTS.days.ago))
    .where(_pAt[:created_at].gt(DATE_WHEN_PICTURES_CHANGED))
    .includes(:variants, :pictures)
    .order('RAND()')

    result = result.only_visible.where(_vAt[:inventory].gt(0).and(_vAt[:price].gt(0))) unless is_admin

    result = result.joins(:variants).
      where(
        _pAt[:category].not_eq(Category::SHOE).
        or(
          _pAt[:category].eq(Category::SHOE).
          and(_vAt[:description].eq(@shoe_size))
        )
    ) if @shoe_size.present?

    result = result.where(category: category) if category.present?
    result.group(_pAt[:id])

    result
  end

end
