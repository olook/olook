class CatalogSearchService
  attr_reader :query_base, :params, :l_products

  def initialize(params)
    @params = params
    @l_products = Catalog::Product.arel_table
    @query_base = @l_products[:catalog_id].eq(@params[:id])

    Rails.logger.debug(params.inspect)
    unless params[:admin]
      @query_base = @query_base.and(@l_products[:inventory].gt(0))
      @query_base = @query_base.and(Variant.arel_table[:inventory].gt(0))
      @query_base = @query_base.and(Product.arel_table[:is_visible].eq(true)).and(Variant.arel_table[:price].gt(0))
    end
  end

  def categories_available_for_options(opts={})
    base_process
    categories = Category.to_a
    if opts[:ignore_category]
      # Removendo a condição das categories
      # POG ALERT: Foi mais fácil que remover a adição já que os filtros dela são muito atrelados
      # Refazer a classe e deixar a seleção de quais filtros vão ser aplicados muito mais simples.
      categories_in_query = @query.group('catalog_products.category_id')
      
      ws = categories_in_query.where_values.map {|an| an.to_sql}.join(' AND ')
      categories_in_query.where_values = [ws.gsub(/(?:|AND )`catalog_products`.`(?:category_id|subcategory_name)` IN \([^\)]*\)/, '')]
      categories_in_query = categories_in_query.includes(:product => [ :variants, :details ]).count.keys
    else
      categories_in_query = @query.group('catalog_products.category_id').includes(:product => [ :variants, :details ]).count.keys
    end
    categories.select! { |opt| categories_in_query.include?(opt.last) }
    categories.unshift(["Ver tudo", nil])
  end

  def search_products
    base_process
    @query.group("catalog_products.product_id")
      .order(generate_order_by_array)
      .paginate(page: @params[:page], per_page: 12)
      .includes(:product => [ :variants, :details ])
  end

  private

  def base_process
    return @query if @query

    add_categories_filter_to_query_base

    add_price_range_to_query_base if @params[:price]

    @query = prepare_query_joins

    add_category_filter_to_query_base
    add_collection_filter_to_query_base
    add_brand_filter_to_query_base

    @query = @query.where(@query_base)
  end

  def filter_product_by(attribute, parameters)
    @query_base.and(l_products[attribute].in(parameters)).and(Variant.arel_table[:description].in(parameters))
  end

  def prepare_query_joins
    query = Catalog::Product.joins(:product).joins(:variant)
    query
  end

  def add_categories_filter_to_query_base

    all_queries = compact_category_queries

    category_query = nil

    all_queries.each do |query|
      category_query = category_query ? category_query.or(query) : query
    end
    unless @params[:admin]
      category_query ||= @params[:shoe_sizes] ? filter_product_by(:shoe_size, @params[:shoe_sizes]) : @query_base
    end

    @query_base = @query_base.and(category_query) if category_query
  end

  def add_category_filter_to_query_base
    # Subcategories filter to make possible to have Shoes / Bags / Accessories pages
    @query_base = @query_base.and(l_products[:category_id].in(@params[:category_id])) if @params[:category_id]
  end

  def add_collection_filter_to_query_base
    if @params[:news]
      if @params[:admin]
        c_id = Collection.find(@params[:news].to_i).id rescue nil
      end
      c_id ||= Collection.active.id
      @query_base = @query_base.and(Product.arel_table[:collection_id].eq(c_id))
    end
  end

  def add_brand_filter_to_query_base
    @query_base = @query_base.and(Product.arel_table[:brand].in(@params[:brands])) if @params[:brands]
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
    build_sub_query((query_heels || query_subcategories_for(@params[:shoe_subcategories]) || query_base), Detail.arel_table[:translation_token].eq("Cor filtro").and(Detail.arel_table[:description].in(@params[:shoe_colors]))) if @params[:shoe_colors]
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
    query = build_sub_query((query || query_base), Detail.arel_table[:translation_token].eq("Cor filtro").and(Detail.arel_table[:description].in(@params[:bag_colors]))) if @params[:bag_colors]
    query.and(l_products[:category_id].in(Category::BAG)) if query
  end

  def query_accessories
    query = query_subcategories_for(@params[:accessory_subcategories])
    query = build_sub_query((query || query_base), Detail.arel_table[:translation_token].eq("Cor filtro").and(Detail.arel_table[:description].in(@params[:accessory_colors]))) if @params[:accessory_colors]
    query.and(l_products[:category_id].in(Category::ACCESSORY)) if query
  end

  def query_clothes
    query = if cloth_size_and_subcategories_selected?
      query_cloth_sizes.and(query_subcategories_for(@params[:cloth_subcategories]))
    else
      query_cloth_sizes || query_subcategories_for(@params[:cloth_subcategories])
    end
    query = cloth_colors(query)
    query.and(l_products[:category_id].in(Category::CLOTH)) if query
  end

  def cloth_size_and_subcategories_selected?
    query_cloth_sizes && query_subcategories_for(@params[:cloth_subcategories])
  end

  def cloth_colors query
    if @params[:cloth_colors]
      build_sub_query((query || query_base), Detail.arel_table[:translation_token].eq("Cor filtro").and(Detail.arel_table[:description].in(@params[:cloth_colors])))
    else
      query
    end
  end

  def build_sub_query(current_query, sub_query)
    current_query == query_base ? sub_query : current_query.and(sub_query)
  end

  def sort_filter
    order_by_price_sql = "CASE WHEN ifnull(catalog_products.retail_price, 0.00) = 0.00 THEN catalog_products.original_price WHEN ifnull(catalog_products.retail_price, 0.00) > 0.00 THEN catalog_products.retail_price END"
    case @params[:sort_filter]
      when "0" then "collection_id desc"
      when "1" then  "#{order_by_price_sql} ASC"
      when "2" then "#{order_by_price_sql} DESC"
      else "collection_id desc"
    end
  end

  def add_price_range_to_query_base
    gt, lt = @params[:price].split('-')
    @query_base = query_base.and(@l_products[:retail_price].gt(gt)) unless gt == "*"
    @query_base = query_base.and(@l_products[:retail_price].lt(lt)) unless lt == "*"
  end

  # def order_by_brands(brands)
  #   "IF(products.brand IN(#{brands.collect{|b| "'#{b}'"}.join(',')}),1,2)"
  # end

  def generate_order_by_array
    order = []
    # order << order_by_brands(@params[:brands]) if @params[:brands]
    order << sort_filter
    order << 'name asc'
    order
  end
end
