class CouponPayment < Payment
  belongs_to :coupon
  validates_presence_of :coupon_id

  def deliver_payment?
    Coupon.transaction do
      coupon = Coupon.lock("LOCK IN SHARE MODE").find_by_id(self.try(:coupon_id))
      if coupon
        coupon.decrement!(:remaining_amount, 1) unless coupon.unlimited?
      end
    end
    super
  end

  def authorize_order?
    Coupon.transaction do
      coupon = Coupon.lock("LOCK IN SHARE MODE").find_by_id(self.try(:coupon_id))
      if coupon
        coupon.increment!(:used_amount, 1)
      end
    end
    super
  end

end
