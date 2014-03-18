require 'spec_helper'

describe UniqueCouponUtilizationPolicy do
  describe ".apply?" do
    context 'coupon is unique per user' do
      let(:coupon) {double(Coupon, one_per_user?: true, id: 100)}
      subject {
        UniqueCouponUtilizationPolicy.apply?(
          coupon: coupon, 
          user_coupon: user_coupon)
      }

      context 'user haven\'t used the coupon' do
        let(:user_coupon) { double(UserCoupon, include?: false)}

        it { should be_true }
      end

      context 'user alredy used the coupon' do
        let(:user_coupon) { double(UserCoupon, include?: true)}
        it { should be_false }

      end

    end

    context 'when there is no user_coupon' do
      subject {UniqueCouponUtilizationPolicy.apply?(coupon: double(Coupon, one_per_user?: nil))}      
      it { should be_true }
    end

  end
end