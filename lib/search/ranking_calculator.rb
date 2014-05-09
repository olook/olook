class RankingCalculator

  RANKING_POWER = 1000
  DAYS_TO_CONSIDER_OLD = 120
  PERCENT_OLOOK_TO_REGULATOR = 100

  attr_reader :age_weight, :max_age_rating, :inventory_weight 

  def initialize
    @age_weight ||= Setting[:age_weight].to_i
    @max_age_rating ||= ( @age_weight * RankingCalculator::RANKING_POWER )
    @inventory_weight ||= Setting[:inventory_weight].to_i
    initialize_count_by_category
  end

  def newest
    return @newest if @newest
    save_temporary_table_vars
    @newest
  end

  def third_quartile_inventory_for_category category
    return @third_quartile_inventory[category] if @third_quartile_inventory
    save_temporary_table_vars
    @third_quartile_inventory[category]
  end

  def save_temporary_table_vars
    create_temporary_products_with_inventory_table do
      initialize_newest
      initialize_third_quartile_inventory
    end
  end

  def create_temporary_products_with_inventory_table
    begin
      drop_existent_temporary_table
      create_temporary_table
      yield
    ensure
      drop_existent_temporary_table
    end
  end

  private

    def initialize_third_quartile_inventory
      count = valid_products_count 

      third_quartile = ( count * 0.75 ).round
      @third_quartile_inventory ||= count_by_category.inject({}) do |hash, aux|
        category, count = aux
        hash[category] = Product.connection.
          select("SELECT sum_inventory FROM products_with_more_than_one_inventory
                   WHERE category = #{category} order by sum_inventory limit 1 offset #{third_quartile}").
          first['sum_inventory']
        hash
      end        
    end

    def initialize_count_by_category
      @count_by_category ||= Product.connection.
        select_all("SELECT category, count(0) `count` from products_with_more_than_one_inventory GROUP BY category").
        inject({}) {|h,r| h[r['category']] = r['count']; h }
    end

    def valid_products_count
      Product.connection.select_all("SELECT count(0) qty FROM products_with_more_than_one_inventory WHERE age < #{DAYS_TO_CONSIDER_OLD}").first['qty']      
    end

    def initialize_newest
      @newest = Product.connection.select("SELECT age FROM products_with_more_than_one_inventory WHERE age < #{DAYS_TO_CONSIDER_OLD} ORDER BY age desc LIMIT 1 OFFSET #{third_quartile}").first['age']      
    end

    def drop_existent_temporary_table
      Product.connection.execute('DROP TEMPORARY TABLE IF EXISTS products_with_more_than_one_inventory')
    end

    def create_temporary_table
      sql = Product.only_visible.joins(:variants).group('products.id').having('sum(inventory) > 0').
        select('products.id, IF(products.launch_date = NULL, 365, CURDATE() - products.launch_date) age,
               products.category, sum(variants.inventory) sum_inventory').to_sql

      Product.connection.execute("CREATE TEMPORARY TABLE products_with_more_than_one_inventory AS #{sql}")      
    end
end