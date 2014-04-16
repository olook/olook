# -*- encoding : utf-8 -*-
class IndexProductsWorker
  extend Fixes

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
  RANKING_POWER = 1000

  @queue = 'low'

  def self.perform
    d0 = Time.now.to_i
    worker = self.new(Product.pluck(:id))
    worker.add_products
    worker.remove_products
    d1 = Time.now.to_i
    
    puts "Total time = #{d1-d0}"

    mail = DevAlertMailer.notify_about_products_index
    mail.deliver
  end

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
        fields['is_visible'] = product.is_visible ? 1 : 0
        fields['brand'] = product.brand.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize
        fields['brand_facet'] = ActiveSupport::Inflector.transliterate(product.brand).gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize
        fields['price'] = (product.price.to_d * 100).round
        fields['retail_price'] = (product.retail_price.to_d * 100).round
        fields['discount'] = (fields['retail_price'].to_i * 100) / fields['price'].to_i
        fields['in_promotion'] = product.liquidation? ? 1 : 0 
        fields['visibility'] = product.visibility
        fields['category'] = product.category_humanize.downcase
        fields['age'] = product.time_in_stock

        # fields that need associations they are all being eager loaded
        fields['name'] = product.formatted_name(150).titleize
        fields['inventory'] = product.inventory.to_i
        fields['care'] = product.subcategory.titleize if Product::CARE_PRODUCTS.include?(product.subcategory)

        fields['image'] = product.catalog_picture
        fields['backside_image'] = product.backside_picture unless product.backside_picture.nil?
        fields['size'] = product.variants.select{|v| v.inventory > 0}.map{|b| (b.description.to_i.to_s != "0" ) ? b.description+product.category_humanize[0].downcase : b.description}
        fields['collection'] = product.collection.start_date.strftime('%Y%m').to_i
        fields['collection_theme'] = product.collection_themes.map { |c| c.slug }


        @age_weight ||= Setting[:age_weight].to_i
        fields['r_age'] = normalize_ranking((older.to_i - product.time_in_stock.to_i), older.to_f, @age_weight)
        @max_age_rating ||= ( @age_weight * RANKING_POWER )
        fields['r_brand_regulator'] = 0
        if /olook/i =~ fields['brand']
          fields['r_brand_regulator'] =  rand( @max_age_rating - fields['r_age'] ) / RANKING_POWER
        end
        @inventory_weight ||= Setting[:inventory_weight].to_i
        fields['r_inventory'] = normalize_ranking(product.inventory.to_f, third_quartile_inventory_for_category(product.category), @inventory_weight)

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

    def upload_sdf_file file_name
      docs_domain =  SEARCH_CONFIG["docs_domain"]
      `curl -X POST --upload-file "#{file_name}" "#{docs_domain}"/2011-02-01/documents/batch --header "Content-Type:application/json"`
    end

    def version_based_on_timestamp
      Time.zone.now.to_i / 60
    end

    def heel_range word
      HeelSanitize.new(word).perform
    end

    def older
      return @older if @older
      save_temporary_table_vars
      @older
    end

    def third_quartile_inventory_for_category(category)
      return @third_quartile_inventory[category] if @third_quartile_inventory
      save_temporary_table_vars
      @third_quartile_inventory[category]
    end

    def save_temporary_table_vars
      create_temporary_products_with_inventory_table do
        count = Product.connection.select_all("SELECT count(0) qty FROM products_with_more_than_one_inventory").
          first['qty']
        third_quartile = ( count * 0.75 ).round
        @older = Product.connection.select("SELECT age FROM products_with_more_than_one_inventory ORDER BY age LIMIT 1 OFFSET #{third_quartile}").
          first['age']

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

    def normalize_ranking(item_value, max, weight)
      factor = ( item_value.to_f / max.to_f ) * weight rescue 0
      ((factor > 1 ? 1 : factor) * RANKING_POWER).to_i
    end

end
