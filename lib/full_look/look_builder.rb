module FullLook
  class LookBuilder
    @queue = 'look'

    def self.perform
      self.new.perform
    end

    def perform
      Look.delete_all
      cloth_products = Product.where(category: Category::CLOTH).pluck(:id)
      category_weight = Hash.new(1)
      category_weight[ Category::CLOTH ] = Setting.look_cloth_category_weight
      category_weight[ Category::ACCESSORY ] = Setting.look_accessory_category_weight
      category_weight[ Category::SHOE ] = Setting.look_shoe_category_weight
      category_weight[ Category::BAG ] = Setting.look_bag_category_weight

      @products = RelatedProduct.where(product_a_id: cloth_products).includes(:product_b, :product_a => :gallery_5_pictures).all

      @products = @products.inject({}) do |h, rp|
        h[rp.product_a_id] ||= {}
        h[rp.product_a_id][:master_product] ||= rp.product_a
        h[rp.product_a_id][:products] ||= []
        h[rp.product_a_id][:products].push(rp.product_b)
        h
      end

      @products.each do |master_product_id, struc|
        master_product = struc[:master_product]
        look = Look.new
        look.product_id = master_product_id
        look.picture = master_product.gallery_5_pictures.first.try(:image_url)
        look.launched_at = master_product.launch_date
        look.profile_id = LookProfileCalculator.calculate([master_product].concat(struc[:products]), category_weight: category_weight)

        look.save
      end
    end
  end
end
