# encoding: utf-8
class Coupon < ActiveRecord::Base
  attr_accessible :code, :brand, :is_percentage, :value,
    :start_date, :end_date, :remaining_amount, :unlimited,
    :active, :campaign, :campaign_description, :modal,
    :updated_by, :created_by, :rule_parameters_attributes,
    :action_parameter_attributes
  COUPON_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/coupons.yml")
  PRODUCT_COUPONS_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/product_coupons.yml")[Rails.env]
  BRAND_COUPONS_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/brand_coupons.yml")[Rails.env]
  MODAL_POSSIBLE_VALUES = { 'Padrão' => 1, "10% em todo site" => 3, "20% apenas marca olook" => 2, "10% Benefícios Club" => 4, "20% Benefícios Club" => 5 }

  validates_presence_of :code, :value, :start_date, :end_date, :campaign, :created_by
  validates_presence_of :remaining_amount, :unless => Proc.new { |a| a.unlimited }
  validates_uniqueness_of :code
  has_many :coupon_payments
  has_many :carts

  has_many :rule_parameters, as: :matchable
  has_many :promotion_rules, :through => :rule_parameters

  has_one :action_parameter, as: :matchable
  has_one :promotion_action, through: :action_parameter

  accepts_nested_attributes_for :rule_parameters, allow_destroy: true, reject_if: lambda { |rule| rule[:promotion_rule_id].blank? }
  accepts_nested_attributes_for :action_parameter, reject_if: lambda { |rule| rule[:promotion_action_id].blank? }

  before_save :set_limited_or_unlimited

  def apply cart
    promotion_action.apply cart, self.action_parameter.action_params, self
    Rails.logger.info "Applied coupon: #{self.name} for cart [#{cart.id}]"
  end

  def name
    "#{code} #{campaign}"
  end

  def desc_value
    promotion_action.desc_value(action_parameter.action_params)
  end

  def modal=(val)
    if MODAL_POSSIBLE_VALUES.values.include?(val.to_i)
      write_attribute(:modal, val.to_i)
    else
      write_attribute(:modal, 1)
    end
  end

  def is_percentage?
    PercentageAdjustment == promotion_action.class
  end

  def available?
    (active_and_not_expired?) ? true : false
  end

  def expired?
    true unless self.start_date < Time.now && self.end_date > Time.now
  end

  def matches?(cart)
    rule_parameters.all? do |rule_param|
      rule_param.matches?(cart)
    end
  end

  def eligible_for_product?(product, opts)
    available? && is_percentage? && matches?(opts[:cart])
  end

  def eligible_for_cart?(cart)
    available? && !is_percentage? && matches?(cart)
  end

  def discount_percent
    self.is_percentage? ? self.value : 0
  end

  def apply_discount_to? product

    if coupon_specific_for_product?
      product_ids = product_ids_allowed_to_have_discount
      product_ids.include?(product.id.to_s)
    elsif coupon_specific_for_brand?
      brand.downcase.split(",").include?(product.brand.downcase)
    else
      true
    end

  end

  def can_be_applied_to_any_product_in_the_cart? cart
    return true if self.brand.blank?
    cart.items.each do |item|
      product = item.product
      return true if apply_discount_to? product
    end
    false
  end

  def calculate_for_product product, opt
    cart = opt[:cart]
    adjustment = promotion_action.simulate_for_product product, cart, self.action_parameter.action_params
    item = cart.items.find { |i| i.product.id == product.id }
    product.price - (adjustment/item.quantity)
  end

  def calculate_for_cart cart
    coupon_value = value if !is_percentage?
    coupon_value ||= 0.0

    if coupon_value >= cart.sub_total
      coupon_value = cart.sub_total
    end
    coupon_value
  end

  private
    def coupon_specific_for_product?
      !product_ids_allowed_to_have_discount.nil?
    end

    def coupon_specific_for_brand?
      !brand.blank?
    end

    def product_ids_allowed_to_have_discount
      product_ids = PRODUCT_COUPONS_CONFIG[self.code]
      product_ids ? product_ids.split(",") : nil
    end

    def active_and_not_expired?
      if self.active? && !expired?
        (ensures_regardless_status) ? true : false
      end
    end

    def set_limited_or_unlimited
      if self.remaining_amount.nil?
        self.unlimited = true
      else
        self.unlimited = nil
      end
    end

    def ensures_regardless_status
      true if self.unlimited? || self.remaining_amount > 0
    end

    def calculated_value(total_price)
      is_percentage ? convert_percentage(total_price) : value
    end

    def convert_percentage(total_price)
      total_price * (value / 100)
    end

end
