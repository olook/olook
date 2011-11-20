require 'spec_helper'

describe Order do
  subject { FactoryGirl.create(:order)}
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35) }
  let(:basic_shoe_40) { FactoryGirl.create(:basic_shoe_size_40) }

  context "calculating the total" do
   it "should return the total" do
     quantity = 3
     expected = basic_shoe_35.price + (quantity * basic_shoe_40.price)
     subject.add_variant(basic_shoe_35)
     quantity.times { subject.add_variant(basic_shoe_40) }
     subject.total.should == expected
   end

   it "should return 0" do
     subject.total.should == 0
   end
  end

  context "when the inventory is zero" do
    before :each do
      basic_shoe_35.update_attributes(:inventory => 0)
    end

    it "should not create line items" do
      expect {
        subject.add_variant(basic_shoe_35)
      }.to change(LineItem, :count).by(0)
    end

    it "should return a nil line item" do
      subject.add_variant(basic_shoe_35).should == nil
    end
  end

  context "when the user try add a new variant" do
    it "should add it in the order" do
      expect {
        subject.add_variant(basic_shoe_35)
      }.to change(LineItem, :count).by(1)
    end

    it "should return a line item" do
      subject.add_variant(basic_shoe_35).should be_a(LineItem)
    end
  end

  context "when the variant already exists in the order" do
    before :each do
      subject.add_variant(basic_shoe_35)
      @line_item = subject.line_items.first
    end

    it "should increment the quantity" do
      first_quantity = @line_item.quantity
      subject.add_variant(basic_shoe_35)
      @line_item.quantity.should == first_quantity + Order::DEFAULT_QUANTITY
    end

    it "should not create line items" do
      expect {
        subject.add_variant(basic_shoe_35)
      }.to change(LineItem, :count).by(0)
    end
  end
end

