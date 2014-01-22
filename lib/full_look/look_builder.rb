module FullLook
  class LookBuilder
    attr_accessor :products, :category_weight 
    @queue = 'look'

    def self.perform
      self.new.perform
    end

    def initialize
      set_category_weight_factor
    end

    def perform
      delete_previous_looks
      set_category_weight_factor
      products = retreive_products
      products = normalize_products

      products.each do |master_product_id, struc|
        master_product = struc[:master_product]
        look = Look.new
        look.product_id = master_product_id
        look.picture = master_product.gallery_5_pictures.first.try(:image_url)
        look.launched_at = master_product.launch_date
        look.profile_id = LookProfileCalculator.calculate([master_product].concat(struc[:products]), category_weight: category_weight)

        look.save
      end
    end


    def delete_previous_looks
      Look.delete_all
    end

    def retreive_products
      cloth_products = Product.cloths.pluck(:id)
      RelatedProduct.with_products(cloth_products).all
    end


    def normalize_products
      products.inject({}) do |h, rp|
        h[rp.product_a_id] ||= {}
        h[rp.product_a_id][:master_product] ||= rp.product_a
        h[rp.product_a_id][:products] ||= []
        h[rp.product_a_id][:products].push(rp.product_b)
        h
      end
    end

    private
    def set_category_weight_factor
      @category_weight = Hash.new(1)
      @category_weight[ Category::CLOTH ] = Setting.look_cloth_category_weight
      @category_weight[ Category::ACCESSORY ] = Setting.look_accessory_category_weight
      @category_weight[ Category::SHOE ] = Setting.look_shoe_category_weight
      @category_weight[ Category::BAG ] = Setting.look_bag_category_weight
    end
  end
end
