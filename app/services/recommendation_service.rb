class RecommendationService

  DAYS_AGO_TO_CONSIDER_NEW = 140
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
    current_limit = limit = opts[:limit] || 5
    products = []

    @profiles.each do |profile|
      products += filtered_list_for_profile(profile, opts).first(current_limit)
      current_limit = limit - products.size
      break if products.size == limit
    end
    products.uniq
  end

  def full_looks(opts={})
    filtered_looks_for_profile(opts)
  end

  private

  def filtered_looks_for_profile(opts={})
    #Look.where(profile_id: @profiles).where(Look.arel_table[:launched_at].gt(DAYS_AGO_TO_CONSIDER_NEW.days.ago)).order('RAND()').first(opts[:limit])
    _pAt = Product.arel_table
    _vAt = Variant.arel_table
    _dAt = Detail.arel_table

    is_admin = opts.fetch(:admin, false)

    result = Product.where(_pAt[:launch_date].gt(DAYS_AGO_TO_CONSIDER_NEW.days.ago))
    .where(_pAt[:created_at].gt(DATE_WHEN_PICTURES_CHANGED))
    .includes(:variants, :pictures)

    result = result.joins(:details).where(_dAt[:translation_token].eq('categoria').and(_dAt[:description].in(WHITELISTED_SUBCATEGORIES)))

    result = result.only_visible.where(_vAt[:inventory].gt(0).and(_vAt[:price].gt(0))) unless is_admin

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

    result
  end

end
