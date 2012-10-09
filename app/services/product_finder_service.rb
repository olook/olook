class ProductFinderService
  attr_reader :user

  def initialize(user, admin=nil, collection=nil)
    @user = user
    @admin = admin
    @collection = collection
  end

  def current_collection
    @collection || Collection.active
  end

  def showroom_products(*args)
    options = args.extract_options!
    options[:collection] = current_collection unless options[:collection]

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
    options[:collection] = current_collection unless options[:collection]

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
    options[:collection] = current_collection unless options[:collection]

    scope = (@admin ? Product : options[:profile].products.only_visible)
    
    scope = scope.joins('left outer join variants on products.id = variants.product_id')
                .select("products.*, if(sum(distinct variants.inventory) > 0, 1, 0) as available_inventory, variants.inventory")
                .where(collection_id: options[:collection])
                .order('available_inventory desc, products.category asc')
                .group('products.id').having(options[:not_allow_sold_out_products] ? "available_inventory = 1" : "")

    scope = scope.where(:category => options[:category]) if options[:category]

    scope = scope.where(variants: {description: options[:description]}) if options[:description] and options[:category] == Category::SHOE
    scope.all
  end

  def suggested_variants_for profile, description
    [profile_products(:profile => profile, :category => Category::SHOE, :description => description).first.variant_by_size(description),
     profile_products(:profile => profile, :category => Category::BAG, :not_allow_sold_out_products => true).first.variant_by_size(description),
     profile_products(:profile => profile, :category => Category::ACCESSORY, :not_allow_sold_out_products => true).first.variant_by_size(description)].compact
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
