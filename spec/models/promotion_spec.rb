# -*- encoding : utf-8 -*-
require "spec_helper"

describe Promotion do
  let(:user) { FactoryGirl.create(:user) }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  subject{ Promotion.new(user, order)}

  it "it should return line items flagged with 'gift' for christmas promotion" do
    order.should_receive(:line_items_with_flagged_gift)
    subject.line_items_for_christmas_promotion
  end
end
