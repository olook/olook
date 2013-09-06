# -*- encoding : utf-8 -*-
class IndexProductsWorker
  extend Fixes

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]

  @queue = :search

  def self.perform
    add_products(Product.all)
    remove_products(Product.all)

    mail = DevAlertMailer.notify_about_products_index
    mail.deliver
  end

  private

    def self.add_products(products)
      add_products = products_to_index(products).map { |product| create_sdf_entry_for(product, 'add') }.compact
      flush_to_sdf_file "/tmp/base-add.sdf", add_products
      upload_sdf_file "/tmp/base-add.sdf"
    end

    def self.remove_products(products)
      remove_products = products_to_remove(products).map { |product| create_sdf_entry_for(product, 'delete') }.compact
      flush_to_sdf_file "/tmp/base-remove.sdf", remove_products
      upload_sdf_file "/tmp/base-remove.sdf"
    end

    def self.flush_to_sdf_file file_name, all_products
      File.open("#{file_name}", "w:UTF-8") do |file|
        file << all_products.to_json
      end
    end


    def self.create_sdf_entry_for product, type
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
        fields['category'] = product.category_humanize.downcase
        fields['size'] = product.variants.select{|v| v.inventory > 0}.map{|b| b.description}
        fields['care'] = product.subcategory.titleize if Product::CARE_PRODUCTS.include?(product.subcategory)
        fields['collection'] = product.collection.start_date.strftime('%Y%m').to_i
        fields['collection_theme'] = product.collection_themes.map { |c| c.slug }
        fields['age'] = p.integration_date.try(:strftime, '%Y%m%d') || ""
        fields['qt_sold_per_day'] = product.quantity_sold_per_day_in_last_week
        fields['coverage_of_days_to_sell'] = product.coverage_of_days_to_sell
        fields['full_grid'] = product.is_the_size_grid_enough? ? 1 : 0

        details = product.details.select { |d| ['categoria','cor filtro','material da sola', 'material externo', 'material interno', 'salto'].include?(d.translation_token.downcase) }
        translation_hash = {
          'categoria' => 'subcategory',
          'cor filtro' => 'color',
          'salto' => 'heel'
        }
        details.each do |detail|
          if detail.translation_token.downcase == 'salto' && product.shoe?
            fields['heel'] = heel_range(detail.description.to_i)
            fields['heeluint'] = detail.description.to_i
          else
            field_key = translation_hash.include?(detail.translation_token.downcase) ? translation_hash[detail.translation_token.downcase] : detail.translation_token.downcase.gsub(" ","_")
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

    def self.upload_sdf_file file_name
      docs_domain =  SEARCH_CONFIG["docs_domain"]
      `curl -X POST --upload-file "#{file_name}" "#{docs_domain}"/2011-02-01/documents/batch --header "Content-Type:application/json"`
    end

    def self.products_to_index(products)
      products.select{|p| p.price > 0 && p.main_picture.try(:image_url)}
    end

    def self.products_to_remove(products)
      products.select{|p| p.price == 0 || p.main_picture.try(:image_url).nil?}
    end

    def self.version_based_on_timestamp
      Time.zone.now.to_i / 60
    end

    def self.heel_range index
      case
        when index < 5
          '0-4 cm'
        when index >= 5 && index < 10
          '5-9 cm'
        when index >= 10
          '10-15 cm'
        else
          ''
      end
    end

end
