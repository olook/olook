# == Schema Information
#
# Table name: payments
#
#  id                         :integer          not null, primary key
#  order_id                   :integer
#  url                        :text
#  created_at                 :datetime
#  updated_at                 :datetime
#  type                       :string(255)
#  state                      :string(255)
#  user_name                  :string(255)
#  credit_card_number         :string(255)
#  bank                       :string(255)
#  expiration_date            :string(255)
#  telephone                  :string(255)
#  user_birthday              :string(255)
#  payments                   :integer
#  gateway_status             :integer
#  gateway_code               :string(255)
#  gateway_type               :string(255)
#  payment_expiration_date    :datetime
#  reminder_sent              :boolean          default(FALSE)
#  gateway_status_reason      :string(255)
#  identification_code        :string(255)
#  cart_id                    :integer
#  credit_type_id             :integer
#  credit_ids                 :text
#  coupon_id                  :integer
#  total_paid                 :decimal(8, 2)
#  promotion_id               :integer
#  discount_percent           :integer
#  percent                    :decimal(8, 2)
#  gateway_response_id        :string(255)
#  gateway_response_status    :string(255)
#  gateway_token              :text
#  gateway_fee                :decimal(8, 2)
#  gateway_origin_code        :string(255)
#  gateway_transaction_status :string(255)
#  gateway_message            :string(255)
#  gateway_transaction_code   :string(255)
#  gateway_return_code        :integer
#  user_id                    :integer
#  gateway                    :integer
#  security_code              :string(255)
#

require 'spec_helper'

describe CouponPayment do
  it { should belong_to(:coupon) }
  it { should validate_presence_of(:coupon_id) }
  
  let(:coupon) { FactoryGirl.create :standard_coupon }
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
      Coupon.any_instance.should_receive(:increment!).with(:used_amount, 1)
      subject.authorize_order?.should be(true)
    end
    
    it "should execute order authorized" do
      subject.coupon = coupon
      order.should_receive(:authorized)
      subject.authorize_order?.should be(true)
    end
  end
end
