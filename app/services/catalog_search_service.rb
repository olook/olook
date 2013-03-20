class CatalogSearchService
  attr_reader :query_base, :params, :l_products

  def initialize(params)
    @params = params
    @l_products = Catalog::Product.arel_table
    @query_base = @l_products[:catalog_id].eq(@params[:id])
                  .and(@l_products[:inventory].gt(0))
                  .and(Product.arel_table[:is_visible].eq(true))
                  .and(Variant.arel_table[:inventory].gt(0))

    if @liquidation = LiquidationService.active
      @query_base = @query_base.and(LiquidationProduct.arel_table[:product_id].eq(nil))
    end

  end

  def categories_available_for_options
    categories = Category.to_a
    categories_in_query = filter_without_paginate.group(:category_id).count.keys
    categories.select! { |opt| categories_in_query.include?(opt.last) }
    categories.unshift(["Todas", nil])
  end

  def cloth_sizes_available
    filter_without_paginate.group('catalog_products.cloth_size').count.keys
  end

  def search_products
    base_process
    @query.group("catalog_products.product_id")
      .order(sort_filter, 'name asc')
      .paginate(page: @params[:page], per_page: 12)
      .includes(product: :variants)
  end

  private

  def filter_without_paginate
    return @query if @query.respond_to?(:to_sql)
    base_process
    @query
  end

  def base_process
    add_categories_filter_to_query_base

    @query = prepare_query_joins

    add_category_filter_to_query_base
    @query = @query.where(@query_base)
  end

  def filter_product_by(attribute, parameters)
    @query_base.and(l_products[attribute].in(parameters)).and(Variant.arel_table[:description].in(parameters))
  end

  def prepare_query_joins
    query = Catalog::Product.joins(:product).joins(:variant)
    query = query.joins('left outer join liquidation_products on liquidation_products.product_id = catalog_products.product_id') if @liquidation
    query
  end

  def add_categories_filter_to_query_base
    all_queries = compact_category_queries

    category_query = nil

    all_queries.each do |query|
      category_query = category_query ? category_query.or(query) : query
    end
    category_query ||= @params[:shoe_sizes] ? filter_product_by(:shoe_size, @params[:shoe_sizes]) : @query_base

    @query_base = @query_base.and(category_query)
  end

  def add_category_filter_to_query_base
    # Subcategories filter to make possible to have Shoes / Bags / Accessories pages
    @query_base = @query_base.and(l_products[:category_id].in(@params[:category_id])) if @params[:category_id]
  end

  def compact_category_queries
    [query_shoes, query_bags, query_accessories, query_clothes].compact
  end

  def query_shoes
    query = [query_shoe_sizes, query_colors, query_heels, query_subcategories_for(@params[:shoe_subcategories])].detect{|query| !query.nil?}
    query.and(l_products[:category_id].in(Category::SHOE)) if query
  end

  def query_shoe_sizes
    build_sub_query((query_colors || query_heels || query_subcategories_for(@params[:shoe_subcategories]) || query_base), filter_product_by(:shoe_size, @params[:shoe_sizes])) if (query_colors || query_heels || query_subcategories_for(@params[:shoe_subcategories])) && @params[:shoe_sizes]
  end

  def query_cloth_sizes
    filter_product_by(:cloth_size, @params[:cloth_sizes]) if @params[:cloth_sizes]
  end

  def query_colors
    build_sub_query((query_heels || query_subcategories_for(@params[:shoe_subcategories]) || query_base), Product.arel_table[:color_name].in(@params[:shoe_colors])) if @params[:shoe_colors]
  end

  def query_heels
    build_sub_query((query_subcategories_for(@params[:shoe_subcategories]) || query_base), l_products[:heel].in(@params[:heels])) if @params[:heels]
  end

  def query_subcategories_for(subcategories)
    if subcategories
      l_products[:subcategory_name].in(subcategories)
    end
  end

  def query_bags
    query = query_subcategories_for(@params[:bag_subcategories])
    query = build_sub_query((query || query_base), Product.arel_table[:color_name].in(@params[:bag_colors])) if @params[:bag_colors]
    query.and(l_products[:category_id].in(Category::BAG)) if query
  end

  def query_accessories
    query = query_subcategories_for(@params[:accessory_subcategories])
    query.and(l_products[:category_id].in(Category::ACCESSORY)) if query
  end

  def query_clothes

    if cloth_size_and_subcategories_selected?
      query = query_cloth_sizes.and(query_subcategories_for(@params[:cloth_subcategories]))
    else
      query = query_cloth_sizes || query_subcategories_for(@params[:cloth_subcategories])
    end

    query.and(l_products[:category_id].in(Category::CLOTH)) if query
  end

  def cloth_size_and_subcategories_selected?
    query_cloth_sizes && query_subcategories_for(@params[:cloth_subcategories])
  end

  def build_sub_query(current_query, sub_query)
    current_query == query_base ? sub_query : current_query.and(sub_query)
  end

  def sort_filter
    case @params[:sort_filter]
      when "0" then "collection_id desc"
      when "1" then "price asc"
      when "2" then "price desc"
      else "collection_id desc"
    end
  end
end
