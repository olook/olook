class ProductFinderService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def showroom_products(category = nil, description = nil)
    categories = category.nil? ? Category.array_of_all_categories : [category]
    results = []
    categories.each do |cat|
      results += products_from_all_profiles(cat, description)[0..4]
    end
    Product.remove_color_variations results
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

  def remove_color_variations(products)
    result = []
    already_displayed = []
    displayed_and_sold_out = {}

    products.each do |product|
      # Only add to the list the products that aren't already shown
      unless already_displayed.include?(product.name)
        result << product
        already_displayed << product.name
        displayed_and_sold_out[product.name] = result.length - 1 if product.sold_out?
      else
        # If a product of the same color was already displayed but was sold out
        # and the algorithm find another color that isn't, replace the sold out one
        # by the one that's not sold out
        if displayed_and_sold_out[product.name] && !product.sold_out?
          result[displayed_and_sold_out[product.name]] = product
          displayed_and_sold_out.delete product.name
        end
      end
    end
    result
  end
end
