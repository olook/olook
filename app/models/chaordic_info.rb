class ChaordicInfo

  def self.user(user, ceid = nil)
    user_pack(user, ceid)
  end

  def self.buy_order order
    order_pack order
  end

  def self.product product
    product_pack product
  end

  def self.cart(cart, user, ceid = nil)
    cart_pack cart, user, ceid
  end

  private

    def self.user_pack(user, ceid = nil)
      chaordic_user_info = set_user(user, ceid)
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
      chaordic_product.image_name = (product.catalog_picture) ? product.catalog_picture.to_s.split('pictures/')[1] : ""
      chaordic_product.name = "#{product.formatted_name}"
      chaordic_product.old_price = product.price.round(2).to_s
      chaordic_product.price = product.retail_price.round(2).to_s
      chaordic_product.description = product.description
      chaordic_product.installment_count = 1
      chaordic_product.installment_price = product.retail_price.round(2).to_s
      product.variants.sort{|x,y| x.description.to_i <=> y.description.to_i}.each do |v|
        size = v.description
        sku = v.inventory >= 1 ? v.sku : ""
        chaordic_product.add_variant size, sku
      end unless product.variants.empty?
      chaordic_product.status = product.inventory > 1 ? "AVAILABLE" : "UNAVAILABLE"
      chaordic_product.sub_category = product.subcategory
      chaordic_product.tags << product.brand
      
      # pulseira do avc shouldn't be shown on any chaordic's showroom
      # We want to avoid showing liquidation and/or marked down products on chaordics showrooms
      chaordic_product.tags << "blacklist" if product.id == 12472 || product.price != product.retail_price

      create_chaordic_object.pack(chaordic_product)
    end

    def self.cart_pack(cart, user, ceid = nil)
      add_to_card_user = set_user(user, ceid)
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

    def self.set_user(user, ceid = nil)
      chaordic_user = Chaordic::Packr::User.new
      if user
        chaordic_user.uid = user.id
        chaordic_user.add_info('Name', user.name)
        chaordic_user.add_info('Email', user.email)
        chaordic_user.add_info('optOut', false)
        chaordic_user.add_info('AuthToken', user.authentication_token)
      elsif ceid
        ce = CampaignEmail.find(ceid)
        chaordic_user.uid = "CS_ANONYMOUSUSER"
        chaordic_user.add_info('userName', "")
        chaordic_user.add_info('userEmail', ce.email)
        chaordic_user.add_info('optOut', false)
        chaordic_user.add_info('AuthToken',"")
      else
        chaordic_user.uid = "CS_ANONYMOUSUSER"
      end
      chaordic_user
    end

    def self.create_chaordic_object
      chaordic_class = Chaordic::Packr::Chaordic.new('4NO8cgqKRJZenICPBL/YtA==')
    end

end
