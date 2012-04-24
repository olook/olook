class ProductFinderService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def showroom_products(*args)
    options = args.extract_options!
    options[:collection] = Collection.active unless options[:collection]

    categories = options[:category].nil? ? Category.list_of_all_categories : [options[:category]]
    results = []
    categories.each do |cat|
      if cat == Category::SHOE
        params = {:category => cat, :description => options[:description], :collection => options[:collection]}
      else
        params = {:category => cat, :not_allow_sold_out_products => options[:not_allow_sold_out_products], :collection => options[:collection]}
      end
      results += products_from_all_profiles(params)[0..4]
    end
    remove_color_variations results
  end

  def products_from_all_profiles(*args)
    options = args.extract_options!
    options[:collection] = Collection.active unless options[:collection]

    result = []
    user.profile_scores.each do |profile_score|
      result = result | profile_products(:profile => profile_score.profile,
                                         :category => options[:category],
                                         :description => options[:description],
                                         :not_allow_sold_out_products => options[:not_allow_sold_out_products],
                                         :collection => options[:collection])
    end
    remove_color_variations result
  end

  def profile_products(*args)
    options = args.extract_options!
    options[:collection] = Collection.active unless options[:collection]

    scope = options[:profile].products.joins(:variants).group("id").only_visible.where(:collection_id => options[:collection]).order("id")
    scope = scope.where(:category => options[:category]) if options[:category]

    vt = Variant.arel_table

    query = vt[:inventory].gt(0) if options[:not_allow_sold_out_products]
    query = vt[:inventory].gt(0).and(vt[:description].eq(options[:description])) if options[:description]

    scope = scope.where(query)
    scope.all
  end

  def suggested_products_for profile, description
    {:shoe => profile_products(:profile => profile, :category => Category::SHOE, :description => description).first,
     :bag => profile_products(:profile => profile, :category => Category::BAG).first,
     :accessory => profile_products(:profile => profile, :category => Category::ACCESSORY).first}
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
