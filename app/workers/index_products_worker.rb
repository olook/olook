# -*- encoding : utf-8 -*-
class IndexProductsWorker
  @queue = :product

  def self.perform
    products = Product.where("collection_id = 20 and is_visible = 1").select{|p| p.inventory > 0}

    all_products=[]
    products.each do |product|
      main_pic = product.main_picture
      if main_pic.nil?
        next
      end

      values = {
        'type' => "add",
        'version' => 1,
        'lang' => 'pt',
        'id' => product.id
      }

      fields = {}

      product.delete_cache

      fields['name'] = product.name
      fields['description'] = product.description
      fields['image'] = main_pic.image_url(:catalog)
      fields['backside_image'] = product.backside_picture
      fields['brand'] = product.brand
      fields['price'] = product.retail_price
      fields['inventory'] = product.inventory
      fields['category'] = product.category_humanize

      details = product.details.delete_if { |d| d.translation_token.downcase == 'salto/tamanho'}

      details.each do |detail|
        # fields[detail.translation_token.to_sym] = detail.description
        fields[detail.translation_token.downcase.gsub(" ","_")] = detail.description
      end

      values['fields'] = fields

      all_products << values
    end

    File.open("base.sdf", "w:UTF-8") do |file| 

      # all_products.each do |prod|
      #   file << prod.to_json
      # end

      file << all_products.to_json
    end

    puts "Finished"
  
  end

end
