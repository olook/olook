class ProductProductDocumentAdapter

  attr_reader :log, :ranking_calculator

  def initialize
    @log = []
    @ranking_calculator = RankingCalculator.new
  end

  def adapt(product, type)
    product_doc = populate_common_fields(product, type)
    product_doc = populate_addition_fields(product, product_doc) if type == 'add'
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
      product_doc.retail_price = product_retail_price_with_discount(product)
      product_doc.calculate_discount
      product_doc.in_promotion = product.liquidation? 
      product_doc.visibility = product.visibility
      product_doc.category = product.category_humanize.downcase
      product_doc.age = product.time_in_stock

      product_doc
    end

    def product_retail_price_with_discount(product)
      product_discount_service = ProductDiscountService.new(product, promotion: Promotion.select_promotion_for(nil))
      product_discount_service.calculate
      product.retail_price
    end

    def populate_keywords_field(product, product_doc)
      color = product.details.find{|d| d.translation_token == "Cor filtro" }.try(:description)
      material = product.details.find{|d| d.translation_token == "material" }.try(:description)
      
      keywords = [product.category_humanize, product.subcategory, product.brand, color, material]
            
      product_doc.keywords = keywords.compact.join(" ")
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

    def add_log_line(product_doc, product)
      @log << ranking_calculator.generate_log_line(product_doc, product)
    end

    def populate_ranking_fields(product, product_doc)
      product_doc.r_age = ranking_calculator.calculate_ranking_age(product_doc)
      product_doc.r_brand_regulator = ranking_calculator.brand_regulator(product_doc.brand)
      proportion = ranking_calculator.calculate_proportion_for_ranking_fields(product)
      product_doc.r_inventory = calculate_r_inventory(proportion) rescue 0

      add_log_line(product_doc, product) if product_doc.inventory > 0 && product_doc.age < RankingCalculator::DAYS_TO_CONSIDER_OLD

      product_doc
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
        product_doc.send("#{field_key}=", format_detail_value(detail.description))
        product_doc.send("#{field_key}=", product_doc.send("#{field_key}").gsub(" Moda Praia", "") + ' Moda Praia') if is_beachwear?(field_key,product_doc.category)
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
      description.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.parameterize(" ")
    end

    def selected_details product
      product.details.to_a.select { |d| d.translation_token.downcase =~ /(categoria|cor filtro)/i }
    end

    def is_beachwear?(field_key,category)
      field_key == 'subcategory' && category == 'moda praia'
    end

    def populate_addition_fields(product, product_doc)
      populate_simple_fields(product, product_doc)
      populate_associated_fields(product, product_doc)
      populate_keywords_field(product, product_doc)
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
