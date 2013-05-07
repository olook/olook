# -*- encoding : utf-8 -*-
class IndexProductsWorker

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]

  @queue = :search

  def self.perform
    all_products = products_to_index.map { |product| create_sdf_entry_for product, 'add' }
    all_products += products_to_remove.map {|product| create_sdf_entry_for product, 'delete'}

    flush_to_sdf_file all_products
    upload_sdf_file 
  end

  private

    def self.flush_to_sdf_file all_products
      File.open("base.sdf", "w:UTF-8") do |file| 
        file << all_products.to_json
      end
    end


    def self.create_sdf_entry_for product, type
      type = "delete" if product.inventory == 0

      values = {
        'type' => type,
        'version' => 1,
        'lang' => 'pt',
        'id' => product.id
      }

      if type == 'add'
        fields = {}

        product.delete_cache

        fields['name'] = product.name
        fields['description'] = product.description
        fields['image'] = product.main_picture.image_url(:catalog)
        fields['backside_image'] = product.backside_picture
        fields['brand'] = product.brand
        fields['price'] = product.retail_price
        fields['inventory'] = product.inventory
        fields['category'] = product.category_humanize

        details = product.details.delete_if { |d| d.translation_token.downcase == 'salto/tamanho'}

        details.each do |detail|
          fields[detail.translation_token.downcase.gsub(" ","_")] = detail.description
        end

        values['fields'] = fields
      end
      values      
    end

    def self.upload_sdf_file
      docs_domain =  SEARCH_CONFIG["docs_domain"]
      `curl -X POST --upload-file base.sdf "#{docs_domain}"/2011-02-01/documents/batch --header "Content-Type:application/json"`
    end

    def self.products_to_index
      products.select{|p| p.is_visible && p.price > 0 && p.main_picture.try(:image_url)}
    end

    def self.products_to_remove
      products.select{|p| !p.is_visible || p.price == 0 || p.main_picture.try(:image_url).nil?}
    end

    def self.products
      Product.all
    end

end
