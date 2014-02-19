class UserCoupon < ActiveRecord::Base
  belongs_to :user
  attr_accessible :coupon_ids

  def add coupon_id
    coupon_array = split_coupon_ids
    coupon_array << coupon_id unless coupon_id.blank? || include?(coupon_id)
    join_and_save_coupon_array coupon_array
  end

  def remove coupon_id
    coupon_array = split_coupon_ids
    coupon_array.delete(coupon_id) unless coupon_id.blank?
    join_and_save_coupon_array coupon_array 
  end

  def include? coupon_id
    split_coupon_ids.include? coupon_id
  end

  private
    def join_and_save_coupon_array coupon_array
      self.coupon_ids = coupon_array.join(",")    
      save      
    end

    def split_coupon_ids
      self.coupon_ids ||= ""
      self.coupon_ids.split(",")      
    end
end
