class RankingCalculator

  RANKING_POWER = 1000
  DAYS_TO_CONSIDER_OLD = 150
  PERCENT_OLOOK_TO_REGULATOR = 100

  AGE_OFFSET = 30
  INVENTORY_OFFSET = {
    Category::SHOE => 40,
    Category::BAG => 10,
    Category::ACCESSORY => 6,
    Category::CLOTH => 15,
    Category::CURVES => 15,
    Category::LINGERIE => 15,
    Category::BEACHWEAR => 15   
  }

  attr_reader :age_weight, :max_age_rating, :inventory_weight 

  def initialize
    @age_weight ||= Setting[:age_weight].to_i
    @max_age_rating ||= ( @age_weight * RankingCalculator::RANKING_POWER )
    @inventory_weight ||= Setting[:inventory_weight].to_i
  end

  def calculate_proportion_for_ranking_fields product
    inventory = INVENTORY_OFFSET.fetch(product.category, 10)
    product.inventory.to_f / inventory
  end

  def brand_regulator brand
    (/olook/i =~ brand) ? 250 : 0
  end

  def calculate_ranking_age product_doc
    diff_age = product_doc.age.to_i - newest
    diff_age = 0 if diff_age < 0
    proportion = diff_age.to_f / DAYS_TO_CONSIDER_OLD.to_f
    proportion = 1 if proportion > 1
    ( ( 1 - proportion ).to_f * RANKING_POWER * age_weight ).to_i
  end

  def calculate_r_inventory proportion
    ( RANKING_POWER * ( proportion > 1 ? 1 : proportion ) * inventory_weight ).to_i
  end

  def newest
    AGE_OFFSET
  end


  def save_temporary_table_vars
    create_temporary_products_with_inventory_table do
      initialize_count_by_category
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

  def generate_log_line(product_doc, product)
    [product.id, product.category, age_log(product_doc), inventory_log(product_doc, product), brand_log(product_doc), exp_log(product_doc)]
  end  

  private

    def initialize_third_quartile_inventory
      count = valid_products_count 
      initialize_newest(first_quartile(count))
      @third_quartile_inventory ||= @count_by_category.inject({}) do |hash, aux|
        category, count = aux
    
        hash[category] = Product.connection.
          select("SELECT sum_inventory FROM products_with_more_than_one_inventory
                   WHERE category = #{category} order by sum_inventory limit 1 offset #{third_quartile(count)}").
          first['sum_inventory']
        hash
      end        
    end

    def first_quartile count
      ( count * 0.25 ).round
    end

    def third_quartile count
      ( count * 0.75 ).round
    end

    def initialize_count_by_category
      @count_by_category ||= Product.connection.
        select_all("SELECT category, count(0) `count` from products_with_more_than_one_inventory GROUP BY category").
        inject({}) {|h,r| h[r['category']] = r['count']; h }
    end

    def valid_products_count
      Product.connection.select_all("SELECT count(0) qty FROM products_with_more_than_one_inventory WHERE age < #{DAYS_TO_CONSIDER_OLD}").first['qty']      
    end

    def initialize_newest offset
      @newest = Product.connection.select("SELECT age FROM products_with_more_than_one_inventory WHERE age < #{DAYS_TO_CONSIDER_OLD} ORDER BY age desc LIMIT 1 OFFSET #{offset}").first['age']      
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

    def age_log product_doc
      "age: #{product_doc.age}/#{newest} - #{product_doc.r_age.to_i}"
    end

    def inventory_log product_doc, product
      inventory = INVENTORY_OFFSET[product.category]
      "#{product_doc.inventory}/#{inventory} - #{product_doc.r_inventory.to_i}"
    end

    def brand_log product_doc
      "#{product_doc.brand} - #{product_doc.r_brand_regulator.to_i}"
    end

    def exp_log product_doc
      normalized_value = ( product_doc.r_age + product_doc.r_inventory + product_doc.r_brand_regulator ).to_i #f / (age_weight + inventory_weight)
      "#{normalized_value.to_i}"
    end    
end
