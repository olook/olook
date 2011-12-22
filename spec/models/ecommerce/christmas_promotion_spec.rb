# -*- encoding : utf-8 -*-
require "spec_helper"

describe ChristmasPromotion do
  let(:user) {  double(:user) }
  let(:order) {  double(:order) }
  subject {ChristmasPromotion.new(order, user)}

  it "should be active" do
    DateTime.stub(:now).and_return(ChristmasPromotion::START_AT + 1.minute)
    subject.is_active?.should be_true
  end

  it "should not be active" do
    DateTime.stub(:now).and_return(ChristmasPromotion::END_AT + 1.minute)
    subject.is_active?.should_not be_true
  end

  context "when the promotion is active" do
    it "should return order line items from promotion" do
      DateTime.stub(:now).and_return(ChristmasPromotion::START_AT + 1.minute)
      subject.order.should_receive(:line_items_with_flagged_gift)
      subject.order_line_items
    end
    context "when the promotion is not active" do
      it "should return order line items" do
        DateTime.stub(:now).and_return(ChristmasPromotion::END_AT + 1.minute)
        subject.order.should_receive(:line_items)
        subject.order_line_items
      end
    end
  end
end
