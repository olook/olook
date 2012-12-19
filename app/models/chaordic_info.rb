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

  def self.add_to_cart cart, user
    add_to_cart_pack cart, user
  end

  private

  # USER
  def self.user_pack user
    if user.kind_of? User
      chaordic_user_info = set_user user.id
      chaordic_user_info.add_info('name', user.name)
      chaordic_user_info.add_info('email', user.email)
    else
      chaordic_user_info = set_user "CS_ANONYMOUSUSER"
    end
    create_chaordic_object.pack(chaordic_user_info)
  end


  # BUY_ORDER
  def self.order_pack order
    order_user = set_user order.user
    order_cart = set_cart order.cart
    order_cart.user = order_user
    chaordic_order = set_order order.id, order_cart
    create_chaordic_object.pack(chaordic_order)
  end




  ########## Metodos auxiliares para buy_order
  def self.set_cart cart
    chaordic_cart = Chaordic::Packr::Cart.new
    cart.items.each do |item|
      chaordic_cart.add_product item.product.id, item.product.retail_price
    end
    chaordic_cart
  end

  def self.set_last_item_cart cart
    chaordic_cart = Chaordic::Packr::Cart.new
    chaordic_cart.add_product cart.items.last.product.id, cart.items.last.product.retail_price
    chaordic_cart
  end

  def self.set_order id, cart
    chaordic_order = Chaordic::Packr::BuyOrder.new(cart)
    chaordic_order.oid = id
    chaordic_order
  end

  def self.set_user user_id
    chaordic_user = Chaordic::Packr::User.new
    chaordic_user.uid = user_id
    chaordic_user
  end


  # PRODUCT
  def self.product_pack product
    chaordic_product = Chaordic::Packr::Product.new
    chaordic_product.pid = product.id
    chaordic_product.category = product.category_humanize
    chaordic_product.detail_url = product.id
    chaordic_product.image_name = product.main_picture.image.to_s.split('pictures/')[1]
    chaordic_product.name = product.name
    chaordic_product.old_price = product.price
    chaordic_product.price = product.retail_price
    chaordic_product.description = product.description
    chaordic_product.installment_count = 1
    chaordic_product.installment_price = product.retail_price
    if product.category == 1
      product.variants.each do |v|
        size = v.description
        sku = product.inventory > 1 ? v.sku : ""
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

  def self.add_to_cart_pack cart, user
    add_to_card_user = set_user user
    add_to_card_cart = set_last_item_cart cart
    add_to_card_cart.user = add_to_card_user
    create_chaordic_object.pack(add_to_card_cart)
  end

  def self.create_chaordic_object
    chaordic_class = Chaordic::Packr::Chaordic.new('4NO8cgqKRJZenICPBL/YtA==')
  end

end
