module FullLook
  class LookBuilder
    @queue = 'low'

    PRODUCTS_MINIMUN_QTY = 2
    MINIMUM_INVENTORY = 1
    ALLOWED_BRANDS_REGEX = /^olook/i
    WHITELISTED_SUBCATEGORIES = [
      'blazer',
      'blusa',
      'camisa',
      'camiseta',
      'casaco',
      'casaco e jaqueta',
      'colete',
      'macacao',
      'regata',
      'top cropped',
      'vestido'
    ]

    def self.perform
      self.new.perform
    end

    def perform
      previous_look_ids = Look.pluck('id')

      look_structure.each do |master_product_id, struc|
        master_product = struc[:master_product]
        look = {}
        look[:product_id] = master_product_id
        look[:full_look_picture] = master_product.full_look_picture.image_url
        look[:front_picture] = master_product.front_picture.image_url
        look[:launched_at] = master_product.launch_date
        look[:profile_id] = get_look_profile([master_product])
        build_and_create_look(look)
      end

      remove previous_look_ids
    end

    def remove ids
      Look.delete_all(id: ids)
    end

    private

    def build_and_create_look(look)
      logger.debug("Criando look")
      Look.build_and_create(look)
    rescue Exception => e
      logger.error("#{ e.class}: #{e.message} \n #{ e.backtrace.join("\n")}")
    end

    def get_look_profile(products)
      LookProfileCalculator.calculate(products, category_weight: category_weight)
    end

    def look_structure
      looks = normalize_products(related_products)
      filter_looks(looks)
    end

    def filter_looks(looks)
      looks.select do |master_product_id, look|
        look[:products].size >= PRODUCTS_MINIMUN_QTY &&
        look[:brands].all? { |b| ALLOWED_BRANDS_REGEX =~ b } &&
        look[:inventories].all? { |i| i >= MINIMUM_INVENTORY } &&
        look[:is_visibles].all? &&
        !look[:master_product].full_look_picture.nil? &&
        !look[:master_product].front_picture.nil?
      end
    end

    def related_products
      cloth_products = Product.cloths.in_subcategory(WHITELISTED_SUBCATEGORIES).pluck(:id)
      RelatedProduct.with_products(cloth_products).all
    end

    def normalize_products(products)
      products.inject({}) do |h, rp|
        logger.debug("Normalizando rp")
        h[rp.product_a_id] ||= {
          master_product: rp.product_a,
          products: [rp.product_a],
          brands: [rp.product_a.brand],
          inventories: [rp.product_a.inventory],
          is_visibles: [rp.product_a.is_visible]
        }
        key = h[rp.product_a_id]

        key[:products].push(rp.product_b)
        key[:brands].push(rp.product_b.brand)
        key[:inventories].push(rp.product_b.inventory)
        key[:is_visibles].push(rp.product_b.is_visible)

        h
      end
    end

    def logger
      Rails.logger
    end

    def category_weight
      @category_weight = Hash.new(1)
      @category_weight[ Category::CLOTH ] = Setting.look_cloth_category_weight
      @category_weight[ Category::ACCESSORY ] = Setting.look_accessory_category_weight
      @category_weight[ Category::SHOE ] = Setting.look_shoe_category_weight
      @category_weight[ Category::BAG ] = Setting.look_bag_category_weight
    end
  end
end
