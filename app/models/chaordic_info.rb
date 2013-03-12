class ChaordicInfo

  def self.user user
    user_pack user
  end

  def self.buy_order order
    order_pack order
  end

  def self.product product
    product_pack product
  end

  def self.cart cart, user
    cart_pack cart, user
  end

  private

    def self.user_pack user
      chaordic_user_info = set_user user
      create_chaordic_object.pack(chaordic_user_info)
    end

    def self.order_pack order
      order_user = set_user order.user
      chaordic_order = set_order order, order_user
      create_chaordic_object.pack(chaordic_order)
    end

    def self.product_pack product
      chaordic_product = Chaordic::Packr::Product.new
      chaordic_product.pid = product.id
      chaordic_product.category = product.category_humanize
      chaordic_product.detail_url = product.id
      chaordic_product.image_name = (product.showroom_picture) ? product.showroom_picture.to_s.split('pictures/')[1] : ""
      chaordic_product.name = "#{product.model_name} #{product.name}"
      chaordic_product.old_price = product.price.round(2).to_s
      chaordic_product.price = product.retail_price.round(2).to_s
      chaordic_product.description = product.description
      chaordic_product.installment_count = 1
      chaordic_product.installment_price = product.retail_price.round(2).to_s
      if product.category == 1
        product.variants.sort{|x,y| x.description.to_i <=> y.description.to_i}.each do |v|
          size = v.description
          sku = v.inventory >= 1 ? v.sku : ""
          chaordic_product.add_variant size, sku
        end
      end
      chaordic_product.status = product.inventory > 1 ? "AVAILABLE" : "UNAVAILABLE"
      chaordic_product.sub_category = product.subcategory
      create_chaordic_object.pack(chaordic_product)
    end

    def self.cart_pack cart, user
      add_to_card_user = set_user user
      add_to_card_cart = set_cart cart
      add_to_card_cart.user = add_to_card_user
      create_chaordic_object.pack(add_to_card_cart)
    end

    def self.set_cart cart
      chaordic_cart = Chaordic::Packr::Cart.new
      cart.items.each do |item|
        chaordic_cart.add_product item.product.id, item.product.retail_price.round(2).to_s, "#{item.variant.sku}:#{cart.id}"
      end
      chaordic_cart
    end

    def self.set_order order, user
      chaordic_order = Chaordic::Packr::Cart.new
      order.line_items.each do |item|
        chaordic_order.add_product item.variant.product.id, item.retail_price.round(2).to_s, item.variant.sku
      end
      chaordic_order.user = user
      chaordic_order = Chaordic::Packr::BuyOrder.new(chaordic_order)
      chaordic_order.oid = order.id
      chaordic_order
    end

    def self.set_user user
      chaordic_user = Chaordic::Packr::User.new
      unless user.nil?
        chaordic_user.uid = user.id
        chaordic_user.add_info('Name', user.name)
        chaordic_user.add_info('Email', user.email)
        chaordic_user.add_info('optOut', false)
        chaordic_user.add_info('AuthToken', user.authentication_token)
      else
        chaordic_user.uid = "CS_ANONYMOUSUSER"
      end
      chaordic_user
    end

    def self.create_chaordic_object
      chaordic_class = Chaordic::Packr::Chaordic.new('4NO8cgqKRJZenICPBL/YtA==')
    end

end
