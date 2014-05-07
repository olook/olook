# -*- encoding : utf-8 -*-
class IndexProductsWorker
  extend Fixes

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
  RANKING_POWER = 1000
  DAYS_TO_CONSIDER_OLD = 120
  PERCENT_OLOOK_TO_REGULATOR = 100

  @queue = 'low'

  def self.perform
    d0 = Time.now.to_i
    worker = self.new(Product.pluck(:id))
    worker.add_products
    worker.remove_products
    d1 = Time.now.to_i

    puts "Total time = #{d1-d0}"

    mail = DevAlertMailer.notify_about_products_index(d1-d0, worker.log.join("\n"))
    mail.deliver
  end

  attr_reader :log

  def add_products
    products.each_slice(500).with_index do |slice, index|
      run slice, index
    end
  end

  def remove_products
    remove_products = products_to_remove(products).map { |product| create_sdf_entry_for(product, 'delete') }.compact
    flush_to_sdf_file "/tmp/base-remove.sdf", remove_products
    upload_sdf_file "/tmp/base-remove.sdf"
  end

  def run slice, index
    begin
      entries = products_to_index(slice).map do |product|
        create_sdf_entry_for(product, 'add')
      end
      entries.compact!
      file_name = "/tmp/base-add#{'%03d' % index}.sdf"
      flush_to_sdf_file file_name, entries
      upload_sdf_file file_name
    rescue => e
      opts = {
        body: "Falha ao gerar o arquivo para indexacao: #{index}-add<br> #{e} <br> #{e.backtrace}",
        to: "tech@olook.com.br",
        subject: "Falha ao rodar a indexacao de produtos"}
      DevAlertMailer.notify(opts).deliver
    end
  end

  private

    attr_reader :products

    def initialize products
      @products = products
      @log = []
    end

    def flush_to_sdf_file file_name, all_products
      File.open("#{file_name}", "w:UTF-8") do |file|
        file << all_products.to_json
      end
    end

    def products_to_index(product_ids)
      _products = Product.where(id: product_ids).where('price > 0').includes(:pictures, :variants, :details, :collection, :collection_themes).all
      _products.select! {|p| p.main_picture && p.main_picture[:image] }
      _products
    end

    def products_to_remove(product_ids)
      _products = Product.where(price: 0).where(id: product_ids).includes(:pictures).all
      _products.select! {|p| p.main_picture.nil? || p.main_picture[:image].nil? }
      _products
    end

    def populate_common_fields(product, type)
      product_doc = ProductDocument.new
      product_doc.type = type
      product_doc.version = version_based_on_timestamp
      product_doc.id = product.id
      product_doc    
    end


    def populate_simple_fields(product, product_doc)
      product_doc.lang = 'pt'

      product_doc.product_id = product.id
      product_doc.is_visible = product.is_visible
      product_doc.brand = product.brand
      product_doc.price = product.price
      product_doc.retail_price = product.retail_price
      product_doc.calculate_discount
      product_doc.in_promotion = product.liquidation? 
      product_doc.visibility = product.visibility
      product_doc.category = product.category_humanize.downcase
      product_doc.age = product.time_in_stock

      product_doc      
    end

    def populate_associated_fields(product, product_doc)
      product_doc.name = product.formatted_name(150)
      product_doc.inventory = product.inventory
      product_doc.care = product.subcategory if belongs_to_care?(product)

      product_doc.image = product.catalog_picture
      product_doc.backside_image = product.backside_picture
      product_doc.size = size_array_for(product)
      product_doc.collection = product.collection.start_date
      product_doc.collection_theme = collection_theme_slugs_for(product)      
    end

    def size_array_for product
      format_variant_descriptions(existent_variants_for(product))      
    end

    def format_variant_descriptions variants
      variants.map{|b| format_variant_description(b)}
    end

    def format_variant_description variant
      string_empty?(variant.description) ? variant.description+product.category_humanize[0].downcase : variant.description
    end

    def string_empty? str
      str.to_i.to_s != "0"
    end

    def existent_variants_for product
      product.variants.select{|v| v.inventory > 0}
    end

    def belongs_to_care? product
      Product::CARE_PRODUCTS.include?(product.subcategory)      
    end

    def collection_theme_slugs_for product
      product.collection_themes.map { |c| c.slug }
    end

    def populate_ranking_fields(product, product_doc)
      @age_weight ||= Setting[:age_weight].to_i

      product_doc.r_age = calculate_ranking_age(product_doc)

      @max_age_rating ||= ( @age_weight * RANKING_POWER )

      product_doc.r_brand_regulator = brand_regulator(product_doc.brand)

      @inventory_weight ||= Setting[:inventory_weight].to_i

      proportion = calculate_proportion_for_ranking_fields(product)

      product_doc.r_inventory = ( RANKING_POWER * ( proportion > 1 ? 1 : proportion ) * @inventory_weight ).to_i rescue 0

      generate_log(product_doc) if product_doc.inventory > 0 && product_doc.age < DAYS_TO_CONSIDER_OLD

      product_doc      
    end

    def calculate_proportion_for_ranking_fields product
      product.inventory.to_f / third_quartile_inventory_for_category(product.category)
    end

    def brand_regulator brand
      (/olook/i =~ brand) ? 250 : 0
    end

    def generate_log product_doc
      @log << [age_log(product_doc), inventory_log(product_doc), brand_log(product_doc), exp_log(product_doc)].join(" | ")
    end

    def age_log product_doc
      "age: #{product_doc.age}/#{newest} - #{product_doc.r_age.to_i}"
    end

    def inventory_log product_doc
      "inventory: #{product_doc.inventory}/#{third_quartile_inventory_for_category(product.category)} - #{product_doc.r_inventory.to_i}"
    end

    def brand_log product_doc
      "brand: #{product_doc.brand} - #{product_doc.r_brand_regulator.to_i}"
    end

    def exp_log product_doc
      "exp: #{( product_doc.r_age + product_doc.r_inventory + product_doc.r_brand_regulator ).to_i}"
    end

    def calculate_ranking_age product_doc
      result = ( RANKING_POWER * @age_weight ).to_i
      result = calculate_proportion_for_ranking_age(product_doc) unless product_doc.age.to_i < newest
      result        
    end

    def calculate_proportion_for_ranking_age product_doc
      diff_age = product_doc.age.to_i - newest.to_i
      proportion = diff_age.to_f / DAYS_TO_CONSIDER_OLD.to_f
      # 0 / 60 = 1, 60 / 60 = 0, 30 / 60 =  0.5, 90 / 60 = 1.5
      proportion = 1 if proportion > 1
      ( 1 - proportion ).to_i
    end

    def populate_shoe_fields(product, product_doc)
      product.details.each do |detail|
        return populate_heel_data(product_doc,detail.description) if matches_heel_regex?(detail.description)
        return populate_heel_data(product_doc,heel) if matches_alternate_heel_regex?(detail.description)
      end
      populate_heel_data(product_doc, '0-4 cm', 0)
    end

    def matches_heel_regex? description
      /\A\d+ ?cm\Z/ =~ description.to_s
    end

    def matches_alternate_heel_regex? description
      /salto: (?<heel>\d+ ?cm)/i =~ description.to_s
    end

    def populate_heel_data(product_doc,heel)
      product_doc.heel = heel_range(heel)
      product_doc.heeluint = heel.to_i
      product_doc
    end


    def populate_details(product, product_doc)
      
      selected_details.each do |detail|
        field_key = get_field_key(detail.translation_token.downcase)
        product_doc[field_key] = format_detail_value(detail.description)
        product_doc[field_key] = product_doc[field_key].gsub(" Moda Praia", "") + ' Moda Praia' if is_beachwear?(field_key,product_doc.category)          
      end

      product_doc      
    end

    def get_field_key translation_token
      translation_hash.include?(translation_token) ? translation_hash[translation_token] : translation_token.gsub(" ","_")
    end

    def translation_hash
      { 'categoria' => 'subcategory', 'cor filtro' => 'color' }
    end

    def format_detail_value description
      description.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize
    end

    def selected_details(product)
      product.details.select { |d| d.translation_token.downcase =~ /(categoria|cor filtro|material da sola|material externo|material interno)/i }
    end

    def is_beachwear?(field_key,category)
      field_key == 'subcategory' && category == 'moda praia'
    end

    def populate_addition_fields(product, product_doc)
      product_doc = populate_simple_fields(product, product_doc)
      product_doc = populate_associated_fields(product, product_doc)
      product_doc = populate_ranking_fields(product,product_doc)
      product_doc = populate_shoe_fields(product, product_doc) if product.shoe?
      product_doc = populate_details(product, product_doc)

      product_doc    
    end

    def create_sdf_entry_for(product, type)
      product_doc = populate_common_fields(product)

      product_doc = populate_addition_fields(product, product_doc) if type == 'add'

      product_doc.to_document
    rescue => e
      Rails.logger.error("Failed to generate sdf of product: #{product.inspect}. Error: #{e.class} #{e.message}\n#{e.backtrace.join("\n")}")
      nil
    end

    def upload_sdf_file file_name
      docs_domain =  SEARCH_CONFIG["docs_domain"]
      `curl -s -X POST --upload-file "#{file_name}" "#{docs_domain}"/2011-02-01/documents/batch --header "Content-Type:application/json"`
    end

    def version_based_on_timestamp
      Time.zone.now.to_i / 60
    end

    def heel_range word
      HeelSanitize.new(word).perform
    end

    def newest
      return @newest if @newest
      save_temporary_table_vars
      @newest
    end

    def third_quartile_inventory_for_category(category)
      return @third_quartile_inventory[category] if @third_quartile_inventory
      save_temporary_table_vars
      @third_quartile_inventory[category]
    end

    def save_temporary_table_vars
      create_temporary_products_with_inventory_table do
        count = Product.connection.select_all("SELECT count(0) qty FROM products_with_more_than_one_inventory WHERE age < #{DAYS_TO_CONSIDER_OLD}").first['qty']
        third_quartile = ( count * 0.75 ).round
        @newest = Product.connection.select("SELECT age FROM products_with_more_than_one_inventory WHERE age < #{DAYS_TO_CONSIDER_OLD} ORDER BY age desc LIMIT 1 OFFSET #{third_quartile}").first['age']

        count_by_category ||= Product.connection.
          select_all("SELECT category, count(0) `count` from products_with_more_than_one_inventory GROUP BY category").
          inject({}) {|h,r| h[r['category']] = r['count']; h }

        @third_quartile_inventory ||= count_by_category.inject({}) do |hash, aux|
          category, count = aux
          third_quartile = ( count*0.75 ).round
          hash[category] = Product.connection.
            select("SELECT sum_inventory FROM products_with_more_than_one_inventory
                     WHERE category = #{category} order by sum_inventory limit 1 offset #{third_quartile}").
            first['sum_inventory']
          hash
        end
      end
    end

    def create_temporary_products_with_inventory_table
      begin
        sql = Product.only_visible.joins(:variants).group('products.id').having('sum(inventory) > 0').
          select('products.id, IF(products.launch_date = NULL, 365, CURDATE() - products.launch_date) age,
                 products.category, sum(variants.inventory) sum_inventory').to_sql
          Product.connection.execute('DROP TEMPORARY TABLE IF EXISTS products_with_more_than_one_inventory')
          Product.connection.execute("CREATE TEMPORARY TABLE products_with_more_than_one_inventory AS #{sql}")
          yield
      ensure
        Product.connection.execute('DROP TEMPORARY TABLE IF EXISTS products_with_more_than_one_inventory')
      end
    end
end
