require 'spec_helper'

describe Order do
  subject { FactoryGirl.create(:order)}
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35) }

  it "should add variants in the order" do
    expect {
      subject.add_variant(basic_shoe_35)
    }.to change(LineItem, :count).by(1)
  end

  it "should increment the variant quantity when already exists" do
    subject.add_variant(basic_shoe_35)
    line_item = subject.line_items.first
    first_quantity = line_item.quantity
    subject.add_variant(basic_shoe_35)
    line_item.quantity.should == first_quantity + Order::DEFAULT_QUANTITY
  end
end

