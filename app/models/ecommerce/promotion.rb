class Promotion < ActiveRecord::Base
  AVG_PRICE_OF_PRODUCTS = 130.0
  validates_presence_of :name

  scope :active, where(:active => true)
  scope :active_and_not_expired, lambda {|date| active.where('starts_at <= :date AND ends_at >= :date', date: date)}

  has_many :promotion_payments

  has_many :rule_parameters, as: :matchable
  has_many :promotion_rules, :through => :rule_parameters

  has_one :action_parameter, as: :matchable
  has_one :promotion_action, through: :action_parameter

  accepts_nested_attributes_for :rule_parameters, allow_destroy: true, reject_if: lambda { |rule| rule[:promotion_rule_id].blank? }
  accepts_nested_attributes_for :action_parameter, reject_if: lambda { |rule| rule[:promotion_action_id].blank? }

  validates_presence_of :action_parameter
  mount_uploader :checkout_banner, ImageUploader

  def apply cart
    promotion_action.apply cart, self.action_parameter.action_params, self
    Rails.logger.info "Applied promotion: #{self.name} for cart [#{cart.id}]"
  end

  def simulate cart
    if cart && cart.items.size > 0
      promotion_action.simulate cart, self.action_parameter.action_params
    else
      if rule_parameters.blank?
        promotion_action.simulate_for_value(AVG_PRICE_OF_PRODUCTS, self.action_parameter.action_params)
      end
    end
  end

  def use_rule_parameters
    rule_parameters.count > 0 ? '1' : '0'
  end

  def use_rule_parameters=(val)
    if val != '1'
      rule_parameters.each do |rp|
        rp.mark_for_destruction
      end
    end
  end

  def calculate_for_product product, opt
    cart = opt[:cart] || Cart.new
    if product.is_visible? && product.master_variant
      cart_items = cart.items.to_a + [CartItem.new(variant: product.master_variant, quantity: 1, cart_id: cart.id)]
      adjustment = promotion_action.simulate_for_product product.id, cart_items, self.action_parameter.action_params
      item = cart_items.find { |i| i.product.id == product.id }
      product.price - (adjustment/(item.try(:quantity) || 1))
    else
      product.price
    end
  end

  def calculate_for_cart cart
    simulate cart
  end

  def self.select_promotion_for(cart)
    promotions_to_apply = matched_promotions_for cart
    best_promotion_for(cart, promotions_to_apply)
  end

  def total_discount_for(cart)
    simulate(cart)
  end

  def matches?(cart)
    matched_all_rules = true
    rule_parameters.each do |rule_param|
      matched_all_rules &&= rule_param.matches?(cart)
    end
    matched_all_rules
  end

  def eligible_for_product? product, opt
    matches?(opt[:cart])
  end

  def eligible_for_cart? cart
    matches?(cart)
  end

  def discount_hash
    discount_hash = nil
    begin
      filters = self.action_parameter.action_params
      discount = self.action_parameter.promotion_action.desc_value filters
      discount_hash = {value: discount.gsub(/(R\$ |\%)/,""), is_percentage: discount.match(/(R\$ )/).blank? }
    rescue
      discount_hash = {}
    end
    discount_hash
  end

  private

    def self.matched_promotions_for cart
      promotions = active_and_not_expired(Date.today).includes(:rule_parameters).all.select do |promotion|
        promotion.matches?(cart)
      end
      promotions
    end

    def self.best_promotion_for(cart, promotions_to_apply = [])
      promotions_totals = calculate(promotions_to_apply, cart)
      best_promotion = promotions_totals.sort_by { |promotion| promotion[:total_discount] }.last
      if best_promotion
        best_promotion[:promotion]
      end
    end

    def self.calculate(promotions_to_apply, cart)
      promotions = []
      promotions_to_apply.map do |promotion|
        promotions << {
          promotion: promotion,
          total_discount: promotion.simulate(cart)
        }
      end
      promotions
    end

    def is_greater_than_coupon?(cart)
      total_discount_for(cart) > cart.coupon.value
    end
end
