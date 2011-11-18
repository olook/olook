require 'spec_helper'

describe Order do
  subject { FactoryGirl.create(:order)}
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35) }

  context "when the user try add a new variant" do
    it "should add it in the order" do
      expect {
        subject.add_variant(basic_shoe_35)
      }.to change(LineItem, :count).by(1)
    end
  end

  context "when the variant already exists in the order" do
    before :each do
      subject.add_variant(basic_shoe_35)
      @line_item = subject.line_items.first
    end

    it "should increment the" do
      first_quantity = @line_item.quantity
      subject.add_variant(basic_shoe_35)
      @line_item.quantity.should == first_quantity + Order::DEFAULT_QUANTITY
    end

    it "should not add it in the order" do
      expect {
        subject.add_variant(basic_shoe_35)
      }.to change(LineItem, :count).by(0)
    end
  end
end

