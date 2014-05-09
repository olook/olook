class ProductProductDocumentAdapter

  attr_reader :log, :ranking_calculator

  def initialize
    @log = []
    @ranking_calculator = RankingCalculator.new
  end

  def adapt(product, type)
    product_doc = populate_common_fields(product, type)
    product_doc = populate_addition_fields(product, product_doc) if type == 'add'
    generate_log(product_doc, product) if product_doc.inventory > 0 && product_doc.age < RankingCalculator::DAYS_TO_CONSIDER_OLD
    product_doc
  rescue => e
    Rails.logger.error("Failed to generate sdf of product: #{product.inspect}. Error: #{e.class} #{e.message}\n#{e.backtrace.join("\n")}")
    nil
  end

  private

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
      product_doc
    end

    def size_array_for product
      format_variant_descriptions(existent_variants_for(product))      
    end

    def format_variant_descriptions variants
      variants.map{|b| format_variant_description(b)}
    end

    def format_variant_description variant
      string_empty?(variant.description) ? variant.description + variant.product.category_humanize[0].downcase : variant.description
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

    def generate_log product_doc, product
      @log << [age_log(product_doc), inventory_log(product_doc, product), brand_log(product_doc), exp_log(product_doc)].join(" | ")
    end

    def age_log product_doc
      "age: #{product_doc.age}/#{ranking_calculator.newest} - #{product_doc.r_age.to_i}"
    end

    def inventory_log product_doc, product
      "inventory: #{product_doc.inventory}/#{ranking_calculator.third_quartile_inventory_for_category(product.category)} - #{product_doc.r_inventory.to_i}"
    end

    def brand_log product_doc
      "brand: #{product_doc.brand} - #{product_doc.r_brand_regulator.to_i}"
    end

    def exp_log product_doc
      "exp: #{( product_doc.r_age + product_doc.r_inventory + product_doc.r_brand_regulator ).to_i}"
    end

    def populate_ranking_fields(product, product_doc)
      product_doc.r_age = calculate_ranking_age(product_doc)
      product_doc.r_brand_regulator = brand_regulator(product_doc.brand)
      proportion = calculate_proportion_for_ranking_fields(product)
      product_doc.r_inventory = ( RankingCalculator::RANKING_POWER * ( proportion > 1 ? 1 : proportion ) * ranking_calculator.inventory_weight ).to_i rescue 0

      product_doc
    end

    def calculate_proportion_for_ranking_fields product
      product.inventory.to_f / ranking_calculator.third_quartile_inventory_for_category(product.category)
    end

    def brand_regulator brand
      (/olook/i =~ brand) ? 250 : 0
    end


    def calculate_ranking_age product_doc
      result = ( RankingCalculator::RANKING_POWER * ranking_calculator.age_weight ).to_i
      result = calculate_proportion_for_ranking_age(product_doc) unless product_doc.age.to_i < ranking_calculator.newest
      result
    end

    def calculate_proportion_for_ranking_age product_doc
      diff_age = product_doc.age.to_i - ranking_calculator.newest.to_i
      proportion = diff_age.to_f / RankingCalculator::DAYS_TO_CONSIDER_OLD.to_f
      # 0 / 60 = 1, 60 / 60 = 0, 30 / 60 =  0.5, 90 / 60 = 1.5
      proportion = 1 if proportion > 1
      ( 1 - proportion ).to_i
    end

    def populate_shoe_fields(product, product_doc)
      product.details.each do |detail|
        return populate_heel_data(product_doc,detail.description) if matches_heel_regex?(detail.description)
        if /salto: (?<heel>\d+ ?cm)/i =~ detail.description.to_s
          return populate_heel_data(product_doc, heel)
        end
      end
      populate_heel_data(product_doc, '0-4 cm', 0)
    end

    def matches_heel_regex? description
      /\A\d+ ?cm\Z/ =~ description.to_s
    end

    def populate_heel_data(product_doc, heel, heeluint=nil)
      product_doc.heel = heel_range(heel)
      product_doc.heeluint = heeluint || heel.to_i
      product_doc
    end

    def populate_details(product, product_doc)
      selected_details(product).each do |detail|
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

    def selected_details product
      product.details.to_a.select { |d| d.translation_token.downcase =~ /(categoria|cor filtro|material da sola|material externo|material interno)/i }
    end

    def is_beachwear?(field_key,category)
      field_key == 'subcategory' && category == 'moda praia'
    end

    def populate_addition_fields(product, product_doc)
      populate_simple_fields(product, product_doc)
      populate_associated_fields(product, product_doc)
      populate_ranking_fields(product,product_doc)
      populate_shoe_fields(product, product_doc) if product.shoe?
      populate_details(product, product_doc)

      product_doc
    end


    def version_based_on_timestamp
      Time.zone.now.to_i / 60
    end

    def heel_range word
      HeelSanitize.new(word).perform
    end
end