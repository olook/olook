# -*- encoding : utf-8 -*-
class IndexProductsWorker
  extend Fixes

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]

  @queue = :search

  def self.perform
    worker = self.new(Product.all)
    worker.add_products
    worker.remove_products

    mail = DevAlertMailer.notify_about_products_index
    mail.deliver
  end

  def add_products
    add_products = products_to_index(products).map { |product| create_sdf_entry_for(product, 'add') }.compact
    flush_to_sdf_file "/tmp/base-add.sdf", add_products
    upload_sdf_file "/tmp/base-add.sdf"
  end

  def remove_products
    remove_products = products_to_remove(products).map { |product| create_sdf_entry_for(product, 'delete') }.compact
    flush_to_sdf_file "/tmp/base-remove.sdf", remove_products
    upload_sdf_file "/tmp/base-remove.sdf"
  end


  private

    def initialize products
      @products = products
    end

    def flush_to_sdf_file file_name, all_products
      File.open("#{file_name}", "w:UTF-8") do |file|
        file << all_products.to_json
      end
    end


    def create_sdf_entry_for product, type
      version = version_based_on_timestamp

      values = {
        'type' => type,
        'version' => version,
        'id' => product.id
      }

      if type == 'add'
        values['lang'] = 'pt'

        fields = {}

        fields['product_id'] = product.id
        fields['name'] = product.formatted_name(150).titleize
        fields['is_visible'] = product.is_visible ? 1 : 0
        fields['inventory'] = product.inventory.to_i
        fields['image'] = product.catalog_picture
        fields['backside_image'] = product.backside_picture unless product.backside_picture.nil?
        fields['brand'] = product.brand.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize
        fields['brand_facet'] = ActiveSupport::Inflector.transliterate(product.brand).gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize
        fields['price'] = (product.price.to_d * 100).round
        fields['retail_price'] = (product.retail_price.to_d * 100).round
        fields['discount'] = (fields['retail_price'].to_i * 100) / fields['price'].to_i
        fields['in_promotion'] = product.liquidation? ? 1 : 0 
        fields['visibility'] = product.visibility
        fields['category'] = product.category_humanize.downcase
        fields['size'] = product.variants.select{|v| v.inventory > 0}.map{|b| (b.description.to_i.to_s != "0" ) ? b.description+product.category_humanize[0].downcase : b.description}
        fields['care'] = product.subcategory.titleize if Product::CARE_PRODUCTS.include?(product.subcategory)
        fields['collection'] = product.collection.start_date.strftime('%Y%m').to_i
        fields['collection_theme'] = product.collection_themes.map { |c| c.slug }
        fields['age'] = product.time_in_stock
        fields['qt_sold_per_day'] = product.quantity_sold_per_day_in_last_week
        fields['coverage_of_days_to_sell'] = product.coverage_of_days_to_sell
        fields['full_grid'] = product.is_the_size_grid_enough? ? 1 : 0

        oldest = older;
        fields['r_age'] = ((oldest - product.time_in_stock) / oldest.to_f) * 100      

        fields['r_coverage_of_days_to_sell'] = ((product.coverage_of_days_to_sell.to_f / max_coverage_of_days_to_sell) * 100).to_i
        fields['r_full_grid'] = product.is_the_size_grid_enough? ? 100 : 0

        if max_qt_sold_per_day == 0
          fields['r_qt_sold_per_day'] = 0
        else
          fields['r_qt_sold_per_day'] = ((product.quantity_sold_per_day_in_last_week.to_f / max_qt_sold_per_day) * 100).to_i
        end

        fields['r_inventory'] = ((product.inventory.to_f / max_inventory) * 100).to_i

        if product.shoe?
          product.details.each do |detail|
            if /cm/i =~ detail.description.to_s
              if /\A\d+ ?cm\Z/ =~ detail.description.to_s
                fields['heel'] = heel_range(detail.description)
                fields['heeluint'] = detail.description.to_i
              elsif /salto: (?:<heel>\d+ ?cm)/i =~ detail.description.to_s
                fields['heel'] = heel_range(heel)
                fields['heeluint'] = heel.to_i
              end
            end
          end
          fields['heel'] ||= '0-4 cm'
          fields['heeluint'] ||= 0
        end
        
        details = product.details.select { |d| d.translation_token.downcase =~ /(categoria|cor filtro|material da sola|material externo|material interno)/i }
        translation_hash = {
          'categoria' => 'subcategory',
          'cor filtro' => 'color'
        }
        details.each do |detail|
          field_key = translation_hash.include?(detail.translation_token.downcase) ? translation_hash[detail.translation_token.downcase] : detail.translation_token.downcase.gsub(" ","_")
          if field_key == 'subcategory' && fields['category'] == 'moda praia'
            fields[field_key] = detail.description.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize.gsub(" Moda Praia", "") + ' Moda Praia'
          else
            fields[field_key] = detail.description.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize
          end
        end
        fields['keywords'] = fields.select{|k,v| ['category', 'subcategory', 'color', 'size', 'name', 'brand', 'material externo', 'material interno', 'material da sola'].include?(k)}.values.join(" ")
        values['fields'] = fields
      end
      values
    rescue => e
      Rails.logger.error("Failed to generate sdf of product: #{product.inspect}. Error: #{e.class} #{e.message}\n#{e.backtrace.join("\n")}")
      nil
    end

    def products
      @products = @products || Product.all
      @products
    end

    def upload_sdf_file file_name
      docs_domain =  SEARCH_CONFIG["docs_domain"]
      `curl -X POST --upload-file "#{file_name}" "#{docs_domain}"/2011-02-01/documents/batch --header "Content-Type:application/json"`
    end

    def products_to_index(products)
      products.select{|p| p.price > 0 && p.main_picture.try(:image_url)}
    end

    def products_to_remove(products)
      products.select{|p| p.price == 0 || p.main_picture.try(:image_url).nil?}
    end

    def version_based_on_timestamp
      Time.zone.now.to_i / 60
    end

    def heel_range word
      HeelSanitize.new(word).perform
    end

    def older
      @older = @older || @products.collect(&:time_in_stock).max
      @older
    end

    def max_coverage_of_days_to_sell
      @max_coverage = @max_coverage || @products.collect(&:coverage_of_days_to_sell).max
      @max_coverage
    end

    def max_qt_sold_per_day
      @max_qt_sold_per_day = @max_qt_sold_per_day || @products.collect(&:quantity_sold_per_day_in_last_week).max
      @max_qt_sold_per_day
    end

    def max_inventory
      @max_inventory = @max_inventory || Product.joins(:variants).order('sum(variants.inventory) desc').group('product_id').first.inventory
      @max_inventory
    end

end
