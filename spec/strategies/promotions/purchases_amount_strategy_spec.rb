require 'spec_helper'

describe Promotions::PurchasesAmountStrategy do
  let(:promo) {FactoryGirl.create(:first_time_buyers)}
  let(:user_with_order_delivered) {FactoryGirl.create(:delivered_order).user}
  let(:order) {user_with_order_delivered.orders.first}

  it "should be applied if the user matches the requirement" do
    Promotions::PurchasesAmountStrategy.new(promo, FactoryGirl.create(:user)).matches?(nil).should be_true
  end

  it "should not be applied if the user matches the requirement" do
    Promotions::PurchasesAmountStrategy.new(promo, user_with_order_delivered ).matches?(nil).should be_false
  end

  it "should return true if is first buy and used promotion" do
    promotion = mock(param: 1)
    order.payments << FactoryGirl.create(:payment, promotion_id: 1)
    Promotions::PurchasesAmountStrategy.new(promotion, user_with_order_delivered, order).matches_20_percent_promotion?.should be_true
  end

  describe "#calculate_promotion_discount" do
    subject { Promotions::PurchasesAmountStrategy.new(promo, FactoryGirl.create(:user)) }
    let(:cart_with_items) { FactoryGirl.create(:cart_with_items) }

    it "returns promotion discount percent as percent" do
      Product.any_instance.should_receive(:retail_price).and_return(100)
      promotion_discount = subject.calculate_promotion_discount(cart_with_items.items)
      promotion_discount[:percent].should eq(20)
    end

    it "returns discount value" do
      Product.any_instance.should_receive(:retail_price).and_return(100)
      promotion_discount = subject.calculate_promotion_discount(cart_with_items.items)
      cart_item = cart_with_items.items.first
      promotion_discount[:value].should eq(30 * cart_item.quantity)
    end

  end


end
