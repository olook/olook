class LiquidationProduct < ActiveRecord::Base
  belongs_to :liquidation
  belongs_to :product

  delegate :name, :to => :product
  delegate :inventory, :to => :product
  delegate :color_name, :to => :product
  delegate :thumb_picture, :to => :product
  delegate :color_sample, :to => :product

  def self.search_products(params)
    liquidation_products = LiquidationProduct.arel_table

    query_base = self.build_query_base(params)
    query_subcategories = params[:subcategories] ? liquidation_products[:subcategory_name].in(params[:subcategories]) : nil
    query_shoe_sizes    = params[:shoe_sizes] ? self.build_sub_query(query_base, (query_subcategories || query_base),liquidation_products[:shoe_size].in(params[:shoe_sizes])) : nil
    query_heels =  params[:heels] ? self.build_sub_query(query_base, (query_shoe_sizes || query_subcategories || query_base), liquidation_products[:heel].in(params[:heels])) : nil
    queries = [query_heels,  query_shoe_sizes, query_subcategories]
    query_result = queries.detect{|query| !query.nil?}
    query_base = query_base.and(query_result) if query_result

    LiquidationProduct.joins(:product).where(query_base).group("product_id").order('category_id asc').paginate(:page => params[:page], :per_page => 12)



  end

  def self.build_query_base(params)
    liquidation_products = LiquidationProduct.arel_table
    liquidation_products[:liquidation_id].eq(params[:id])
  end

  def self.build_sub_query(base_query, current_query, sub_query)
    if current_query == base_query
      sub_query
    else
      current_query.or(sub_query)
    end
  end
end
