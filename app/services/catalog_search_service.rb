class CatalogSearchService
  SORT_FILTER = {:lowest_price => "0", :highest_price => "1"}
  attr_reader :query_base, :params, :l_products

  def initialize(params)
    @l_products = Catalog::Product.arel_table
    @query_base = @l_products[:catalog_id].eq(params[:id])
                  .and(@l_products[:inventory].gt(0))
                  .and(Product.arel_table[:is_visible].eq(true))
                  
    if @liquidation = LiquidationService.active
      @query_base = @query_base.and(LiquidationProduct.arel_table[:liquidation_id].eq(@liquidation.id))
                    .and(LiquidationProduct.arel_table[:product_id].eq(nil))
    end

    @params = params
  end

  def search_products
    query_subcategories = params[:shoe_subcategories] ? l_products[:subcategory_name].in(params[:shoe_subcategories]) : nil
    query_shoe_sizes = params[:shoe_sizes] ? build_sub_query((query_subcategories || query_base),l_products[:shoe_size].in(params[:shoe_sizes])) : nil
    query_heels =  params[:heels] ? build_sub_query((query_shoe_sizes || query_subcategories || query_base), l_products[:heel].in(params[:heels])) : nil

    queries = [query_heels,  query_shoe_sizes, query_subcategories]
    query_result = queries.detect{|query| !query.nil?}

    query_bags_acessories = params[:bag_accessory_subcategories] ? l_products[:subcategory_name].in(params[:bag_accessory_subcategories]) : nil

    if query_bags_acessories
      @query_base = query_result ? @query_base.and(query_result.or(query_bags_acessories)) : @query_base.and(query_bags_acessories)
    else
      @query_base = @query_base.and(query_result) if query_result
    end

    #TODO: ADD in includes: master_variant, main_picture
    @query = Catalog::Product.joins(:product)
    if @liquidation
      @query = @query.joins('left outer join liquidation_products on liquidation_products.product_id = catalog_products.product_id')
    end
    @query.where(@query_base)
          .order("category_id asc, #{sort_filter}")
          .group("catalog_products.product_id")
          .paginate(page: params[:page], per_page: 12)
          .includes(product: :variants)
  end

  def build_sub_query(current_query, sub_query)
    current_query == query_base ? sub_query : current_query.and(sub_query)
  end

  def sort_filter
    params[:sort_filter] == SORT_FILTER[:highest_price] ? "retail_price desc" : "retail_price asc"
  end
end
