class ProductFinderService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def products_from_all_profiles(category = nil, description = nil)
    result = []
    user.profile_scores.each do |profile_score|
      result = result | profile_products(profile_score.profile, category, description)
    end
    Product.remove_color_variations result
  end

  def profile_products(profile, category = nil, description = nil)
    scope = profile.products.joins(:variants).group("id").only_visible.where(:collection_id => Collection.active)
    scope = scope.where(:category => category) if category
    if description
      vt = Variant.arel_table
      query = vt[:inventory].gt(0).and(vt[:description].eq(description))
      scope = scope.where(query)
    end
    scope.all
  end
end
