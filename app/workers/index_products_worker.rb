# -*- encoding : utf-8 -*-
class IndexProductsWorker
  extend Fixes

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]

  @queue = :search

  def self.perform
    add_products
    # remove_products

    mail = DevAlertMailer.notify_about_products_index
    mail.deliver
  end

  private

    def self.add_products
      add_products = products_to_index.map { |product| create_sdf_entry_for product, 'add' }
      flush_to_sdf_file "base-add.sdf", add_products
      # upload_sdf_file "base-add.sdf"
    end

    def self.remove_products
      remove_products = products_to_remove.map {|product| create_sdf_entry_for product, 'delete'}
      flush_to_sdf_file "base-remove.sdf", remove_products
      upload_sdf_file "base-remove.sdf"
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

        remove_product_item_view_cache product.id

        fields['name'] = product.formatted_name(100)
        # fields['description'] = product.description
        fields['image'] = product.catalog_picture
        fields['backside_image'] = product.backside_picture unless product.backside_picture.nil?
        fields['brand'] = product.brand
        fields['brand_facet'] = product.brand
        fields['price'] = product.price
        fields['retail_price'] = product.retail_price
        fields['in_promotion'] = product.price != product.retail_price
        fields['category'] = product.category_humanize

        details = product.details.select { |d| ['categoria','cor filtro','material da sola', 'material externo', 'material interno'].include?(d.translation_token.downcase) }

        details.each do |detail|
          fields[detail.translation_token.downcase.gsub(" ","_")] = detail.description
        end

        values['fields'] = fields
      end
      values
    end

    def self.upload_sdf_file file_name
      docs_domain =  SEARCH_CONFIG["docs_domain"]
      `curl -X POST --upload-file "#{file_name}" "#{docs_domain}"/2011-02-01/documents/batch --header "Content-Type:application/json"`
    end

    def self.products_to_index
      products.select{|p| p.is_visible && p.price > 0 && p.main_picture.try(:image_url) && p.inventory > 0}
    end

    def self.products_to_remove
      products.select{|p| !p.is_visible || p.price == 0 || p.main_picture.try(:image_url).nil? || p.inventory == 0}
    end

    def self.products
      Product.all
    end

    def self.version_based_on_timestamp
      Time.zone.now.to_i / 60
    end

end
