class LiquidationSearchService
  SORT_FILTER = {:lowest_price => "0", :highest_price => "1"}
  attr_reader :query_base, :params, :l_products

  def initialize(params)
    @l_products = LiquidationProduct.arel_table
    @query_base = @l_products[:liquidation_id].eq(params[:id]).and(@l_products[:inventory].gt(0)).and(Product.arel_table[:is_visible].eq(true))
    @params = params
  end

  def search_products
    query_subcategories = params[:shoe_subcategories] ? l_products[:subcategory_name].in(params[:shoe_subcategories]) : nil
    query_shoe_sizes = params[:shoe_sizes] ? build_sub_query((query_subcategories || query_base),l_products[:shoe_size].in(params[:shoe_sizes])) : nil
    query_heels =  params[:heels] ? build_sub_query((query_shoe_sizes || query_subcategories || query_base), l_products[:heel].in(params[:heels])) : nil

    queries = [query_heels,  query_shoe_sizes, query_subcategories]
    query_result = queries.detect{|query| !query.nil?}
    @query_base = query_base.and(query_result) if query_result

    query_bags_acessories = params[:bag_accessory_subcategories] ? l_products[:subcategory_name].in(params[:bag_accessory_subcategories]) : nil

    @query_base = @query_base.or(query_bags_acessories) if query_bags_acessories

    LiquidationProduct.joins(:product).where(query_base)
                                      .group("product_id")
                                      .order("category_id asc, #{sort_filter}")
                                      .paginate(:page => params[:page], :per_page => 12)
  end

  def build_sub_query(current_query, sub_query)
    current_query == query_base ? sub_query : current_query.and(sub_query)
  end

  def sort_filter
    params[:sort_filter] == SORT_FILTER[:highest_price] ? "retail_price desc" : "retail_price asc"
  end
end
