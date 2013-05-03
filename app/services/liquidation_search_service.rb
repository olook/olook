class LiquidationSearchService
  attr_reader :query_base, :params, :l_products

  def initialize(params)
    @l_products = LiquidationProduct.arel_table
    @query_base = @l_products[:liquidation_id].eq(params[:id])
                  .and(@l_products[:inventory].gt(0))
                  .and(Product.arel_table[:is_visible].eq(true))
                  .and(Variant.arel_table[:price].gt(0))

    @params = params
  end

  def search_products
    query_subcategories = params[:shoe_subcategories] ? l_products[:subcategory_name].in(params[:shoe_subcategories]) : nil
    query_heels =  params[:heels] ? build_sub_query((query_subcategories || query_base), l_products[:heel].in(params[:heels])) : nil

    query_shoe_sizes = params[:shoe_sizes] ? build_sub_query((query_heels || query_subcategories || query_base), l_products[:shoe_size].in(params[:shoe_sizes])) : nil

    queries = [query_shoe_sizes, query_heels, query_subcategories]
    query_result = queries.detect{|query| !query.nil?}

    query_bags = params[:bag_subcategories] ? l_products[:subcategory_name].in(params[:bag_subcategories]) : nil
    query_accessories = params[:accessory_subcategories] ? l_products[:subcategory_name].in(params[:accessory_subcategories]) : nil
    query_bags_and_accessories = query_bags && query_accessories ? query_bags.or(query_accessories) : (query_bags || query_accessories)

    if query_bags_and_accessories
      @query_base = @query_base.and(query_bags_and_accessories)
    else
      @query_base = @query_base.and(query_result) if query_result
    end

    # color filters
    query_colors = params[:colors] ? Product.arel_table[:color_name].in(params[:colors]) : nil
    @query_base = @query_base.and(query_colors) if query_colors

    LiquidationProduct.joins(:product).joins(:variant).where(query_base)
                                      .order(sort_filter, 'name asc')
                                      .group("liquidation_products.product_id")
                                      .paginate(page: params[:page], per_page: 12)
  end

  def build_sub_query(current_query, sub_query)
    current_query == query_base ? sub_query : current_query.and(sub_query)
  end

  def sort_filter
    case params[:sort_filter]
      when "0" then "category_id asc"
      when "1" then "retail_price asc"
      when "2" then "retail_price desc"
      else "retail_price asc"
    end
  end
end
