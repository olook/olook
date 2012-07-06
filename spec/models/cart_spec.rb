require 'spec_helper'

describe Cart do
  it { should belong_to(:user) }
  it { should have_one(:order) }
  it { should have_many(:cart_items) }


  context "when the inventory is not available" do
    before :each do
      basic_shoe_35.update_attributes(:inventory => 10)
    end

    it "should not create line items" do
      expect {
        subject.add_variant(basic_shoe_35, 11)
      }.to change(LineItem, :count).by(0)
    end

    it "should return a nil line item" do
      subject.add_variant(basic_shoe_35, 11).should == nil
    end
  end

  context "when the inventory is available" do
    before :each do
      basic_shoe_35.update_attributes(:inventory => 10)
      basic_shoe_40.update_attributes(:inventory => 10)
    end

    it "should set product's retail price to retail price when the item doesn't belongs to a liquidation" do
      subject.add_variant(basic_shoe_40, 1)
      line_item = subject.line_items.detect{|l| l.variant.id == basic_shoe_40.id}
      line_item.retail_price.should == basic_shoe_40.product.retail_price
    end

    it "should always set the retail price even when the item belongs to a liquidation" do
      basic_shoe_40.stub(:liquidation?).and_return(true)
      basic_shoe_40.product.stub(:retail_price).and_return(retail_price = 45.90)
      subject.add_variant(basic_shoe_40, 1)
      line_item = subject.line_items.detect{|l| l.variant.id == basic_shoe_40.id}
      line_item.retail_price.should == retail_price
    end

    it "should create line items" do
      expect {
        subject.add_variant(basic_shoe_35, 10)
      }.to change(LineItem, :count).by(1)
    end


    it "should not return a nil line item" do
      subject.add_variant(basic_shoe_35, 10).should_not == nil
    end
  end

  context "items availables in the order" do
    before :each do
      basic_shoe_35.update_attributes(:inventory => 10)
      subject.add_variant(basic_shoe_35, 2)

      basic_shoe_40.update_attributes(:inventory => 10)
      subject.add_variant(basic_shoe_40, 5)
    end

    context "when all variants are available" do
      it "should return 0 for #remove_unavailable_items" do
        subject.remove_unavailable_items.should == 0
      end

      it "should has 2 line items" do
        subject.remove_unavailable_items
        subject.line_items.count.should == 2
      end
    end

    context "when at least one variant is unavailable" do
      it "should return 1 for #remove_unavailable_items" do
        basic_shoe_40.update_attributes(:inventory => 3)
        subject.remove_unavailable_items.should == 1
      end

      it "should has just 1 line item" do
        basic_shoe_40.update_attributes(:inventory => 3)
        subject.remove_unavailable_items
        subject.line_items.count.should == 1
      end
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

    it "should update the quantity" do
      first_quantity = @line_item.quantity
      subject.add_variant(basic_shoe_35, quantity)
      @line_item.quantity.should == quantity
    end

    it "should not create line items" do
      expect {
        subject.add_variant(basic_shoe_35)
      }.to change(LineItem, :count).by(0)
    end
  end

  context "removing a variant" do
    before :each do
      subject.add_variant(basic_shoe_35)
    end

    describe "with a valid variant" do
      it "should destroy the variant line item" do
        expect {
          subject.remove_variant(basic_shoe_35)
        }.to change(LineItem, :count).by(-1)
      end
    end

    describe "with a invalid variant" do
      it "should not destroy the variant line item" do
        expect {
          subject.remove_variant(basic_shoe_40)
        }.to change(LineItem, :count).by(0)
      end

      it "should return a nil item" do
        subject.remove_variant(basic_shoe_40).should be(nil)
      end
    end
  end  


  context "destroying an Order" do
    before :each do
      subject.add_variant(basic_shoe_35)
      subject.add_variant(basic_shoe_40)
    end

    it "should destroy the order" do
      expect {
        subject.destroy
      }.to change(Order, :count).by(-1)
    end

    it "should destroy line items" do
      expect {
        subject.destroy
      }.to change(LineItem, :count).by(-2)
    end
  end
  
  describe "unrestricted order should accept products from vitrine" do
    subject { FactoryGirl.create(:clean_order)}

    it "should return true to add gift and normal products to the same cart" do
      subject.restricted?.should be_false
    end
  end

  describe "restricted order should accept products from vitrine" do
    subject { FactoryGirl.create(:restricted_order)}

    it "should be marked as restricted" do
      subject.restricted?.should be_true
    end
  end

end