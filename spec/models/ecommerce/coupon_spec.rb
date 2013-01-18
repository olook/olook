require 'spec_helper'

describe Coupon do
  let(:standard_coupon) { FactoryGirl.create(:standard_coupon) }
  let(:expired_coupon) { FactoryGirl.create(:expired_coupon) }
  let(:unlimited_coupon) { FactoryGirl.create(:unlimited_coupon) }
  let(:limited_coupon) { FactoryGirl.create(:limited_coupon) }
  subject { FactoryGirl.create(:standard_coupon, value: 100) }

  context 'validations' do
    it {should validate_presence_of(:code)}
    it {should validate_presence_of(:value)}
    it {should validate_presence_of(:start_date)}
    it {should validate_presence_of(:end_date)}
    it {should validate_presence_of(:campaign)}
    it {should validate_presence_of(:created_by)}
    it {should validate_presence_of(:remaining_amount)}

    it "should be invalid if coupon if limited and dont have a remaining_amount" do
      coupon = FactoryGirl.build(:standard_coupon)
      coupon.remaining_amount = ''
      coupon.should_not be_valid
    end
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

  context "#apply_discount_to?" do

    let(:product_coupon) { FactoryGirl.create(:product_coupon) }

    it "should be true for product 9640" do
      product_coupon.apply_discount_to?(9640).should be_true
    end

    it "should be false for product 9641" do
      product_coupon.apply_discount_to?(9641).should be_false
    end

  end

  describe "#should_apply_to?" do
    let(:promotion) { mock_model(Promotion)}
    let(:cart) { mock_model Cart}
    
    context "when value is greater than promotion discount value" do
      it "returns true" do
        Promotion.should_receive(:select_promotion_for).and_return(promotion)
        promotion.should_receive(:total_discount_for).and_return(50)
        subject.should_apply_to?(cart).should be_true
      end
    end

    context "when value is smaller than promotion discount value" do
      it "returns false" do
        Promotion.should_receive(:select_promotion_for).and_return(promotion)
        promotion.should_receive(:total_discount_for).and_return(150)
        subject.should_apply_to?(cart).should be_false
      end
    end

    context "when there's no promotion for cart" do
      it "returns true" do
        Promotion.should_receive(:select_promotion_for).and_return(nil)
        subject.should_apply_to?(cart).should be_true
      end
    end
  end
end