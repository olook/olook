class Coupon < ActiveRecord::Base
  validates_presence_of :code, :value, :start_date, :end_date

  before_save :set_limited_or_unlimited

  def available?
    (active_and_not_expired?) ? true : false
  end

  def expired?
    true unless self.start_date < Time.now && self.end_date > Time.now
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
