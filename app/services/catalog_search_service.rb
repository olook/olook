class CatalogSearchService
  attr_reader :query_base, :params, :l_products

  def initialize(params)
    @l_products = Catalog::Product.arel_table
    @query_base = @l_products[:catalog_id].eq(params[:id])
                  .and(@l_products[:inventory].gt(0))
                  .and(Product.arel_table[:is_visible].eq(true))
                  .and(Variant.arel_table[:inventory].gt(0))
                  
    if @liquidation = LiquidationService.active
      @query_base = @query_base.and(LiquidationProduct.arel_table[:product_id].eq(nil))
    end

    @params = params
  end

  def search_products
    query_subcategories = params[:shoe_subcategories] ? l_products[:subcategory_name].in(params[:shoe_subcategories]) : nil
    query_heels =  params[:heels] ? build_sub_query((query_subcategories || query_base), l_products[:heel].in(params[:heels])) : nil
    query_colors = params[:shoe_colors] ? build_sub_query((query_heels || query_subcategories || query_base), Product.arel_table[:color_name].in(params[:shoe_colors])) : nil
    query_shoe_sizes = if (query_colors || query_heels || query_subcategories) && params[:shoe_sizes]
      build_sub_query((query_colors || query_heels || query_subcategories || query_base), l_products[:shoe_size].in(params[:shoe_sizes]).and(Variant.arel_table[:description].in(params[:shoe_sizes])))
    else
      nil
    end

    query_shoes = [query_shoe_sizes, query_colors, query_heels, query_subcategories].detect{|query| !query.nil?}
    query_shoes = query_shoes.and(l_products[:category_id].in(Category::SHOE)) if query_shoes

    query_bags = params[:bag_subcategories] ? l_products[:subcategory_name].in(params[:bag_subcategories]) : nil
    query_bags = build_sub_query((query_bags || query_base), Product.arel_table[:color_name].in(params[:bag_colors])) if params[:bag_colors]
    query_bags = query_bags.and(l_products[:category_id].in(Category::BAG)) if query_bags

    query_accessories = params[:accessory_subcategories] ? l_products[:subcategory_name].in(params[:accessory_subcategories]) : nil
    query_accessories = query_accessories.and(l_products[:category_id].in(Category::ACCESSORY)) if query_accessories
    
    all_queries = [query_shoes, query_bags, query_accessories].compact
    
    @query_base = case all_queries.size
      when 1 then
        @query_base.and(all_queries[0])
      when 2 then
        @query_base.and(all_queries[0].or(all_queries[1]))
      when 3 then
        @query_base.and(all_queries[0].or(all_queries[1]).or(all_queries[2]))
      else
        params[:shoe_sizes] ? @query_base.and(l_products[:shoe_size].in(params[:shoe_sizes])).and(Variant.arel_table[:description].in(params[:shoe_sizes])) : @query_base
    end
    
    @query = Catalog::Product.joins(:product).joins(:variant)
    if @liquidation
      @query = @query.joins('left outer join liquidation_products on liquidation_products.product_id = catalog_products.product_id')
    end
    @query.where(@query_base)
          .order(sort_filter, 'name asc')
          .group("catalog_products.product_id")
          .paginate(page: params[:page], per_page: 12)
          .includes(product: :variants)
  end

  def build_sub_query(current_query, sub_query)
    current_query == query_base ? sub_query : current_query.and(sub_query)
  end

  def sort_filter
    case params[:sort_filter]
      when "1" then "retail_price asc"
      when "2" then "retail_price desc"
      else "category_id asc"
    end
  end
end
