require 'spec_helper'

describe Coupon do
  let(:standard_coupon) { FactoryGirl.create(:standard_coupon) }
  let(:expired_coupon) { FactoryGirl.create(:expired_coupon) }
  let(:unlimited_coupon) { FactoryGirl.create(:unlimited_coupon) }
  let(:limited_coupon) { FactoryGirl.create(:limited_coupon) }

  context 'validations' do
    it {should validate_presence_of(:code)}
    it {should validate_presence_of(:value)}
    it {should validate_presence_of(:start_date)}
    it {should validate_presence_of(:end_date)}
  end

  context 'methods' do
    it 'should be true if coupon is available' do
      standard_coupon.available?.should be_true
    end

    it 'should be false if coupon is not available' do
      expired_coupon.available?.should be_false
    end

    it 'should be true if coupon is expired' do
      expired_coupon.expired?.should be_true
    end

    it 'should be false if coupon is not expired' do
      standard_coupon.expired?.should be_false
    end
  end

  context 'callbacks' do
    it 'should set unlimited as true when remaining_amount is nil' do
      unlimited_coupon.unlimited.should be_true
    end

    it 'should set unlimited as false when remaining_amount is 1 or more' do
      limited_coupon.unlimited.should be_false
    end
  end
end
