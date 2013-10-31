# -*- encoding : utf-8 -*-
class CartService
  attr_accessor :cart
  attr_accessor :prefered_shipping_services

  delegate :allow_credit_payment?, :to => :cart
  delegate :total_promotion_discount, :to => :cart, :prefix => :cart
  delegate :total_coupon_discount, :to => :cart, :prefix => :cart
  delegate :sub_total, :to => :cart, :prefix => :cart

  def self.gift_wrap_price
    YAML::load_file(Rails.root.to_s + '/config/gifts.yml')["values"][0]
  end

  def initialize(params)
    params.each_pair do |key, value|
      self.send(key.to_s+'=',value)
    end
  end

  def freight
    cart.address ? freight_for_zip_code(cart.address.zip_code).merge({address: cart.address}) : {}
  end

  def freight_for_zip_code zip_code
    FreightCalculator.freight_for_zip(zip_code, subtotal, prefered_shipping_services)
  end

  def freight_price
    freight && freight.fetch(:price, 0) || 0
  end

  def freight_city
    freight && freight.fetch(:city, "") || ""
  end

  def freight_state
    freight && freight.fetch(:state, "") || ""
  end

  def item_price(item)
    get_retail_price_for_item(item).fetch(:price)
  end

  def item_retail_price(item)
    get_retail_price_for_item(item).fetch(:retail_price)
  end

  def item_promotion?(item)
    item.has_adjustment?
  end

  def item_price_total(item)
    item_price(item) * item.quantity
  end

  def item_retail_price_total(item)
    item_retail_price(item) * item.quantity
  end

  def item_discount_percent(item)
    get_retail_price_for_item(item).fetch(:percent)
  end

  def item_discount_origin(item)
    get_retail_price_for_item(item).fetch(:origin)
  end

  def item_discount_origin_type(item)
    get_retail_price_for_item(item).fetch(:origin_type)
  end

  def item_discounts(item)
    discounts = get_retail_price_for_item(item).fetch(:discounts)
    # For compatibility reason
    # Terrible. Improve it
    discounts << :promotion if item.has_adjustment? && cart.coupon && !should_override_promotion_discount?

    discounts
  end

  def subtotal(type = :retail_price)
    return 0 if cart.nil? || (cart && cart.items.nil?)
    cart.items.inject(0) do |value, item|
      value += self.send("item_#{type}_total", item)
    end
  end

  def total_increase
    increase = 0
    increase += cart.increment_from_gift_wrap
    increase += freight_price
    increase
  end

  def total_coupon_discount
    calculate_discounts.fetch(:total_coupon)
  end

  def total_credits_discount
    calculate_discounts.fetch(:total_credits)
  end

  def billet_discount
    calculate_discounts(Billet.new).fetch(:billet_discount)
  end

  def debit_discount
    calculate_discounts(Debit.new).fetch(:debit_discount)
  end

  def facebook_discount
    calculate_discounts.fetch(:facebook_discount)
  end

  def total_discount(payment=nil)
    discounts_value = calculate_discounts(payment).fetch(:total_discount)
    discounts_value += CartService.gift_wrap_price if cart.free_gift_wrap?
    discounts_value
  end

  def is_minimum_payment?
    calculate_discounts.fetch(:is_minimum_payment)
  end

  def total_discount_by_type(type, payment=nil)
    total_value = 0
    total_value += total_coupon_discount if :coupon == type
    total_value += calculate_discounts.fetch(:total_credits_by_invite) if :credits_by_invite == type
    total_value += calculate_discounts.fetch(:total_credits_by_redeem) if :credits_by_redeem == type
    total_value += calculate_discounts.fetch(:total_credits_by_loyalty_program) if :credits_by_loyalty_program == type
    total_value += calculate_discounts(payment).fetch(:debit_discount) if :debit_discount == type
    total_value += calculate_discounts(payment).fetch(:billet_discount) if :billet_discount == type
    total_value += calculate_discounts.fetch(:facebook_discount) if :facebook_discount == type

    cart.items.each do |item|
      if item_discount_origin_type(item) == type
        total_value += (item_price(item) - item_retail_price(item))
      end
    end

    total_value
  end

  def active_discounts
    discounts = cart.items.inject([]) do |discounts, item|
      discounts + item_discounts(item)
    end

    discounts.uniq
  end

  def has_more_than_one_discount?
    active_discounts.size > 1
  end

  def total(payment=nil)
    # total = subtotal(:retail_price)

    total = cart_sub_total
    total += total_increase
    total -= total_discount(payment)
    # total -= cart_total_promotion_discount unless should_override_promotion_discount?

    total = Payment::MINIMUM_VALUE if total < Payment::MINIMUM_VALUE
    total
  end

  def gross_amount
    self.subtotal(:price) + self.total_increase
  end

  def generate_order!(gateway, tracking = nil, payment = nil)
    raise ActiveRecord::RecordNotFound.new('A valid cart is required for generating an order.') if cart.nil?
    raise ActiveRecord::RecordNotFound.new('A valid freight is required for generating an order.') if freight.nil?
    raise ActiveRecord::RecordNotFound.new('A valid user is required for generating an order.') if cart.user.nil?

    user = cart.user

    order = Order.create!(
      :cart_id => cart.id,
      :user_id => user.id,
      :restricted => cart.has_gift_items?,
      :gift_wrap => cart.gift_wrap,
      :amount_discount => total_discount(payment),
      :amount_increase => total_increase,
      :amount_paid => total(payment),
      :subtotal => subtotal,
      :user_first_name => user.first_name,
      :user_last_name => user.last_name,
      :user_email => user.email,
      :user_cpf => user.cpf,
      :gross_amount => self.gross_amount,
      :gateway => gateway,
      :tracking => tracking
    )

    order.line_items = []

    cart.items.each do |item|

      order.line_items << LineItem.new(variant_id: item.variant.id, quantity: item.quantity, price: item_price(item),
                    retail_price: normalize_retail_price(order, item), gift: item.gift)

      create_freebies_line_items_and_update_subtotal(order, item)
    end

    order.freight = Freight.create(freight)
    order.save
    order
  end

  def normalize_retail_price(order, cart_item)
    retail_price = item_retail_price(cart_item)
    if retail_price == 0
      retail_price = 0.1
      order.amount_discount += retail_price
      order.subtotal += retail_price
    end
    retail_price
  end

  def create_freebies_line_items_and_update_subtotal(order, item)
    freebies = FreebieVariant.where(variant_id: item.variant.id).map { |freebie_variant| LineItem.new( variant_id: freebie_variant.freebie.id,
              quantity: item.quantity, price: 0.1, retail_price: 0.1, gift: item.gift, is_freebie: true) }
    order.line_items << freebies
    order.amount_discount += (freebies.size * 0.1)
    order.subtotal += (freebies.size * 0.1)
  end

  def amount_for_loyalty_program
    LoyaltyProgramCreditType.apply_percentage(total + total_discount_by_type(:credits_by_redeem))
  end

  def should_override_promotion_discount?
    cart.total_coupon_discount > cart_total_promotion_discount
  end

  def get_retail_price_for_item(item)
    origin = ''
    percent = 0
    final_retail_price = item.retail_price
    final_retail_price ||= 0
    price = item.price
    discounts = []
    origin_type = ''

    if price != final_retail_price && !item.has_adjustment? && cart.coupon.nil?
      Rails.logger.info("[OLOOKLET] Calculating Olooklet retail price for item")
      percent =  (1 - (final_retail_price / price) )* 100
      origin = 'Olooklet: '+percent.ceil.to_s+'% de desconto'
      discounts << :olooklet
      origin_type = :olooklet
    end

    coupon = cart.coupon

    if coupon && !coupon.is_percentage?
      discounts << :coupon_of_value
    end

    if coupon && coupon.is_percentage? && coupon.apply_discount_to?(item.product) && item.product.can_supports_discount?
      discounts << :coupon
      coupon_value = price - ((coupon.value * price) / 100)
      if coupon_value < final_retail_price && should_override_promotion_discount?
        percent = coupon.value
        final_retail_price = coupon_value
        origin = 'Desconto de '+percent.ceil.to_s+'% do cupom '+coupon.code
        origin_type = :coupon
      end
    end

    #if
    # facebook_discount_value = calculate_facebook_discount_value(final_retail_price)
    # final_retail_price -= facebook_discount_value
    # discounts << :facebook

    {
      :origin       => origin,
      :price        => price,
      :retail_price => final_retail_price,
      :percent      => percent,
      :discounts    => discounts,
      :origin_type  => origin_type
    }
  end

  def minimum_value
    return 0.0 if freight_price > Payment::MINIMUM_VALUE
    Payment::MINIMUM_VALUE
  end

  def calculate_discounts(payment=nil)
    discounts = []
    retail_value = self.subtotal(:retail_price) - minimum_value
    retail_value = 0.0 if retail_value < 0
    total_discount = 0.0
    billet_discount_value = 0.0
    debit_discount_value = 0.0
    facebook_discount_value = 0.0

    cd = CartDiscountService.new(cart, coupon: cart.coupon)
    coupon_value = cd.discount

    retail_value -= coupon_value

    use_credits = self.cart.use_credits
    credits_loyality = 0.0
    credits_invite = 0.0
    credits_redeem = 0.0
    if (use_credits == true && self.cart.user)

      # Use loyalty only if there is no product with olooklet discount in the cart
      credits_loyality = allow_credit_payment? ? self.cart.user.user_credits_for(:loyalty_program).total : 0.0
      if credits_loyality >= retail_value
        credits_loyality = retail_value
      end

      retail_value -= credits_loyality

      #GET FROM INVITE
      credits_invite = allow_credit_payment? ? self.cart.user.user_credits_for(:invite).total : 0.0
      if credits_invite >= retail_value
        credits_invite = retail_value
      end

      retail_value -= credits_invite

      #GET FROM REDEEM
      credits_redeem = self.cart.user.user_credits_for(:redeem).total
      if credits_redeem >= retail_value
        credits_redeem = retail_value
      end

      retail_value -= credits_redeem

    end

    if cart.facebook_share_discount?
      facebook_discount_value = calculate_facebook_discount_value(retail_value)
      retail_value -= facebook_discount_value
    end

    if payment && payment.is_a?(Billet) && Setting.billet_discount_available

      billet_discount_value = calculate_billet_discount_value(retail_value)

      if billet_discount_value > retail_value
        billet_discount_value = retail_value
      end
      retail_value -= billet_discount_value
    end

    if payment && payment.is_a?(Debit) && Setting.debit_discount_available

      debit_discount_value = calculate_debit_discount_value(retail_value)

      if debit_discount_value > retail_value
        debit_discount_value = retail_value
      end
      retail_value -= debit_discount_value
    end

    total_credits = credits_loyality + credits_invite + credits_redeem

    discounts << :coupon if coupon_value > 0.0
    discounts << :billet_discount if billet_discount_value > 0
    discounts << :debit_discount if billet_discount_value > 0

    {
      :discounts                         => discounts,
      :is_minimum_payment                => (minimum_value > 0 && retail_value <= 0),
      :total_discount                    => (coupon_value + total_credits + billet_discount_value + debit_discount_value + facebook_discount_value),
      :billet_discount                   => billet_discount_value,
      :debit_discount                    => debit_discount_value,
      :facebook_discount                 => facebook_discount_value,
      :total_coupon                      => coupon_value,
      :total_credits_by_loyalty_program  => credits_loyality,
      :total_credits_by_invite           => credits_invite,
      :total_credits_by_redeem           => credits_redeem,
      :total_credits                     => total_credits
    }
  end


  def calculate_debit_discount_value retail_value
    debit_discount_percent = (Setting.debit_discount_percent.to_i / 100.0).to_d
    debit_discount_value = (retail_value.to_d + minimum_value.to_d) * debit_discount_percent
    debit_discount_value.round(2, BigDecimal::ROUND_HALF_UP)
  end

  def calculate_billet_discount_value retail_value
    billet_discount_percent = (Setting.billet_discount_percent.to_i / 100.0).to_d
    billet_discount_value = (retail_value.to_d + minimum_value.to_d) * billet_discount_percent
    billet_discount_value.round(2, BigDecimal::ROUND_HALF_UP)
  end

  def calculate_facebook_discount_value retail_value
    facebook_discount_percent = 0.02.to_d
    facebook_discount_value = (retail_value.to_d + minimum_value.to_d) * facebook_discount_percent
    facebook_discount_value.round(2, BigDecimal::ROUND_HALF_UP)
  end

  def has_percentage_coupon?
    self.cart.coupon.present? && self.cart.coupon.is_percentage?
  end

  def price_with_coupon_for product
    coupon = self.cart.coupon
    return product.retail_price if should_not_calculate? product, coupon
    calculate_percentage_discount_for product, coupon
  end

  private
    def calculate_percentage_discount_for product, coupon
      product.price - ((product.price * coupon.value) / 100)
    end

    def should_not_calculate? product, coupon
      coupon.nil? || !coupon.is_percentage? || product.promotion?
    end

end
