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
      flush_to_sdf_file "/tmp/base-add.sdf", add_products
      upload_sdf_file "/tmp/base-add.sdf"
    end

    def self.remove_products
      remove_products = products_to_remove.map {|product| create_sdf_entry_for product, 'delete'}
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

        fields['name'] = product.formatted_name(150)
        fields['description'] = product.description
        fields['image'] = product.catalog_picture
        fields['backside_image'] = product.backside_picture unless product.backside_picture.nil?
        fields['brand'] = product.brand
        fields['brand_facet'] = product.brand
        fields['price'] = product.price
        fields['retail_price'] = product.retail_price
        fields['in_promotion'] = product.promotion?
        fields['category'] = product.category_humanize
        fields['size'] = product.variants.map(&:description).map{|b| "-#{b}-"}

        details = product.details.select { |d| ['categoria','cor filtro','material da sola', 'material externo', 'material interno', 'salto'].include?(d.translation_token.downcase) }

        details.each do |detail|
          if detail.translation_token.downcase == 'salto' && product.shoe?
            binding.pry if product.shoe?
            fields['salto'] = heel_range(detail.description.to_i)
          else
            fields[detail.translation_token.downcase.gsub(" ","_")] = detail.description.split(" ").first.to_i
          end
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
      Product.joins(:variants).joins(:details).all
    end

    def self.version_based_on_timestamp
      Time.zone.now.to_i / 60
    end

    def self.heel_range index
      case index
      when index < 5
        '0-4'
      when index >= 5 && index < 10
        '5-9'
      else
        '10-15'
      end
    end    

end
