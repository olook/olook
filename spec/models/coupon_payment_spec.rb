require 'spec_helper'

describe CouponPayment do
  it { should belong_to(:coupon) }
  it { should validate_presence_of(:coupon_id) }
  
  let(:coupon) { FactoryGirl.create :standard_coupon }
  let(:user) {FactoryGirl.create :user}
  let(:user_coupon) { FactoryGirl.create(:user_coupon, user: user) }  
  let(:order) { mock_model(Order, :authorized => true) }
  
  subject { CouponPayment.new(:order => order) }
  
  context "when deliver payment" do
    it "should return true" do
      subject.deliver_payment?.should be(true)
    end
    
    it "should return true if cupon is not found" do
      subject.coupon_id = 1234
      subject.deliver_payment?.should be(true)
    end
    
    it "should execute decrement remaning if cupon is not ulimited" do
      subject.coupon = coupon
      Coupon.any_instance.should_receive(:decrement!).with(:remaining_amount, 1)
      subject.deliver_payment?.should be(true)
    end
  end
  
  context "when authorize payment" do
    it "should return true" do
      subject.authorize_order?.should be(true)
    end
    
    it "should return true if cupon is not found" do
      subject.coupon_id = 1234
      subject.authorize_order?.should be(true)
    end
    
    it "should execute increment used" do
      subject.coupon = coupon
      subject.user = user
      Coupon.any_instance.should_receive(:one_per_user?).and_return(false)
      Coupon.any_instance.should_receive(:increment!).with(:used_amount, 1)
      subject.authorize_order?.should be(true)
    end
    
    it "should execute order authorized" do
      subject.coupon = coupon
      subject.user = user
      Coupon.any_instance.should_receive(:one_per_user?).and_return(false)      
      order.should_receive(:authorized)
      subject.authorize_order?.should be(true)
    end
  end
end
