class PriceModificator
  def initialize(cart)
    @cart = cart
  end

  def discounts
    if items_are_gift? || (items_discounts_total > discount_from_money_coupon)
      bigger_discount = { :product_discount => items_discount }
    else
      bigger_discount = { :money_coupon => { :value => discount_from_money_coupon, :code => cart.used_coupon.try(:code) }}
    end

    bigger_discount.merge({ :credits => { :value => discount_from_credits } })
  end

  def increments
    {
      :gift_wrap => { :wrapped => cart.gift_wrap?, :value => increment_from_gift },
      :freight => { :value => increment_from_freight }
    }
  end

  def items_discounts_total
    items_discount.values.map(&:value).inject(&:+)
  end

  def items_discount_conflict
    conflicted_discounts = items.map{|item| item_discounts_conflict(item)}.flatten.select{|item_discount| !item_discount.nil?}
    conflicted_discounts.group_by(&:item)
  end

  def items_discount_conflict?
    items.select{|item| item_discounts_conflict?(item) }.any?
  end

  def items_discount
    cart_items = Hash.new
    items.map do |item|
      cart_items[item] = discount_for_item(item)
    end
    cart_items
  end

  def original_price
    items_price
  end

  def discounted_price
    original_price - items_discounts_total
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
    cart.items
  end

  def items_price
    items.map(&:total_price).inject(&:+)
  end

  def items_retail_price
    items.map(&:total_retail_price).inject(&:+)
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
    if cart.freight && cart.freight[:price]
      cart.freight[:price]
    else
      0
    end
  end

  #Calculators
  def items_are_gift?
    items.select(&:gift).any?
  end

  def discount_for_item(item)
    if item.gift
      value = item.original_price - item.original_retail_price
      Discount.new(:origin => :gift, :value => value , :item => item)
    else
      item_discounts(item).max_by(&:value)
    end
  end

  def item_discounts_conflict(item)
    item_discounts(item).select{|x| x.value > 0}
  end

  def item_discounts_conflict?(item)
    item_discounts_conflict(item).size > 1
  end

  def item_discounts(item)
    [item_olooklet_discount(item), item_coupon_discount(item), item_promotion_discount(item)]
  end

  def item_olooklet_discount(item)
    value = item.original_price - item.original_retail_price
    Discount.new(:origin => :olooklet, :item => item, :value => value )
  end

  def item_coupon_discount(item)
    coupon = used_coupon
    if coupon && coupon.is_percentage?
      Discount.new(:origin => :coupon, :item => item, :percentage => coupon.value)
    else
      Discount.new(:origin => :coupon, :item => item)
    end
  end

  def discount_from_money_coupon
    unless !used_coupon || used_coupon.is_percentage?
      [used_coupon.value, max_discount].min
    else
      0
    end
  end

  def item_promotion_discount(item)
    Discount.new(:origin => :promotion , :item => item , :percentage => used_promotion.try(:discount_percent))
  end

  def total_with_freight
    total + (freight_price || 0)
  end

  def discount_from_credits
    if credits > max_credit_value
      max_credit_value
    else
      credits
    end
  end

  def increment_from_gift
    cart.gift_wrap? ? gift_price : 0
  end

  def increment_from_freight
    freight_price || 0
  end

  def minimum_value
    return 0 if freight_price > Payment::MINIMUM_VALUE
    Payment::MINIMUM_VALUE
  end

  def total
    total = original_price + total_increment - total_discount
    total > minimum_value ? total : minimum_value
  end

  def total_discount
    [discount_from_money_coupon, items_discounts_total].max + credits
  end

  def total_increment
    increment_from_freight + increment_from_gift
  end

  #Limiters
  def max_discount
    items_price - minimum_value
  end

  def max_credit_value
    max_credit_possible = max_discount - items_discounts_total + discount_from_money_coupon

    [max_credit_possible , 0].max
  end
end

