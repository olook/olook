# == Schema Information
#
# Table name: coupons
#
#  id                   :integer          not null, primary key
#  code                 :string(255)
#  value                :decimal(8, 2)
#  remaining_amount     :integer
#  unlimited            :boolean
#  active               :boolean
#  start_date           :datetime
#  end_date             :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  is_percentage        :boolean
#  used_amount          :integer          default(0)
#  campaign             :string(255)
#  campaign_description :string(255)
#  created_by           :string(255)
#  updated_by           :string(255)
#

class Coupon < ActiveRecord::Base
  # TODO: Temporarily disabling paper_trail for app analysis
  #has_paper_trail :on => [:update, :destroy]

  COUPON_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/coupons.yml")
  PRODUCT_COUPONS_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/product_coupons.yml")[Rails.env]

  validates_presence_of :code, :value, :start_date, :end_date, :campaign, :created_by
  validates_presence_of :remaining_amount, :unless => Proc.new { |a| a.unlimited }
  validates_uniqueness_of :code
  has_many :coupon_payments

  before_save :set_limited_or_unlimited

  def available?
    (active_and_not_expired?) ? true : false
  end

  def expired?
    true unless self.start_date < Time.now && self.end_date > Time.now
  end

  def discount_percent
    self.is_percentage? ? self.value : 0
  end

  def apply_discount_to? product_id
    products_related = PRODUCT_COUPONS_CONFIG[self.code]
    is_the_product_related = products_related.nil? || products_related.split(",").include?(product_id.to_s)
  end
  
  private

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

end
