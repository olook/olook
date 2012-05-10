class CatalogSearchService
  SORT_FILTER = {:lowest_price => "0", :highest_price => "1"}
  attr_reader :query_base, :params, :l_products

  def initialize(params)
    @l_products = Catalog::Product.arel_table
    @query_base = @l_products[:catalog_id].eq(params[:id]).and(@l_products[:inventory].gt(0)).and(Product.arel_table[:is_visible].eq(true))
                  .and(LiquidationProduct.arel_table[:product_id].eq(l_products[:product_id]).not)
    @params = params
  end

  def search_products
    query_subcategories = params[:shoe_subcategories] ? l_products[:subcategory_name].in(params[:shoe_subcategories]) : nil
    query_shoe_sizes = params[:shoe_sizes] ? build_sub_query((query_subcategories || query_base),l_products[:shoe_size].in(params[:shoe_sizes])) : nil
    query_heels =  params[:heels] ? build_sub_query((query_shoe_sizes || query_subcategories || query_base), l_products[:heel].in(params[:heels])) : nil

    queries = [query_heels,  query_shoe_sizes, query_subcategories]
    query_result = queries.detect{|query| !query.nil?}

    query_bags_acessories = params[:bag_accessory_subcategories] ? l_products[:subcategory_name].in(params[:bag_accessory_subcategories]) : nil

    @query_base = if query_bags_acessories
      query_result ? @query_base.and(query_result.or(query_bags_acessories)) : @query_base.and(query_bags_acessories)
    else
      @query_base.and(query_result) if query_result
    end

    Catalog::Product.where(@query_base)
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

  def self.remove_color_variations(products)
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
