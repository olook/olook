class PriceModificator
  def initialize(cart)
    @cart = cart
  end

  def discounts
    {
      :promotion => { :value => discount_from_promotion },
      :coupon => { :value => discount_from_coupon },
      :product_discount => { :value => discount_from_items },
      :credits => { :value => discount_from_credits }
    }
  end

  def increments
    {
      :gift_wrap => { :wrapped => @cart.gift_wrap? },
      :freight => { :value => freight_price }
    }
  end

  def original_price
    items_price
  end

  def final_price
    total
  end

  private

  #Accessors
  def cart
    @cart
  end

  def items
    cart.line_items
  end

  def items_price
    BigDecimal.new(items.inject(0){|result, item| result + item.total_price}.to_s)
  end

  def items_retail_price
    BigDecimal.new(items.inject(0){|result, item| result + item.total_retail_price}.to_s)
  end

  def used_coupon
    cart.used_coupon
  end

  def used_promotion
    cart.used_promotion
  end

  def credits
    credits_to_use = cart.credits
    credits_to_use.nil? ? 0 : credits_to_use
  end

  def gift_price
    YAML::load_file(Rails.root.to_s + '/config/gifts.yml')["values"][0]
  end

  def freight_price
    cart.freight_price
  end

  #Calculators

  def total_with_freight
    total + (freight_price || 0)
  end

  def discount_from_coupon
    if used_coupon
      discount_value = used_coupon.is_percentage? ? (used_coupon.value * items_price) / 100 : used_coupon.value
      discount_value > max_discount ? max_discount : discount_value
    else
      0
    end
  end

  def discount_from_credits
    if credits > max_credit_value
      max_credit_value
    else
      credits
    end
  end

  def discount_from_promotion
    used_promotion ? used_promotion.discount_value : 0
  end

  def discount_from_items
    items_price - items_retail_price
  end

  def increment_from_gift
    gift_wrap? ? gift_price : 0
  end

  def increment_from_freight
    freight_price || 0
  end

  def subtotal
    items_price
  end

  def total
    total = subtotal + total_increment - total_discount
    total > Payment::MINIMUM_VALUE ? total : Payment::MINIMUM_VALUE
  end

  def total_discount
    if discount_from_coupon > 0
      credits + discount_from_coupon
    else
      credits + discount_from_promotion
    end
  end


  #Limiters
  def max_discount
    items_price - Payment::MINIMUM_VALUE
  end

  def max_credit_value
    max_credit_possible = max_discount

    if discount_from_coupon > 0
      max_credit_possible -= discount_from_coupon
    else
      max_credit_possible -= discount_from_promotion
    end

    max_credit_possible > 0 ? max_credit_possible : 0
  end

end


