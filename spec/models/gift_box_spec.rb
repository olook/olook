require 'spec_helper'

describe GiftBox do

  let!(:product_a) { FactoryGirl.create(:shoe, :casual) }
  let!(:product_b) { FactoryGirl.create(:basic_bag) }
  let!(:product_c) { FactoryGirl.create(:basic_accessory) }

  subject do
    FactoryGirl.create(:gift_box, :product_list => { product_c.id => "1" })
  end

  describe "#validations" do
    it { should validate_presence_of :name }
  end

  describe "update gift box products" do
    before do
      subject.update_attributes(:product_list => { "#{product_a.id}" => "1",  "#{product_b.id}" => "2"})
    end

    it "sets product_a and product_b as related products" do
      subject.products.should == [product_a, product_b]
    end

    it "sets product_a and product_b as lookbook products" do
      subject.products.map(&:product_id).should == [product_a.id, product_b.id]
    end
  end

  describe "#suggestion_products" do


    it "should return 5 products ordering by inventory" do
      product_1 = mock_model("Product", id: 25, inventory: 1)
      product_2 = mock_model("Product", id: 26, inventory: 2)
      product_3 = mock_model("Product", id: 27, inventory: 3)
      product_4 = mock_model("Product", id: 28, inventory: 4)
      product_5 = mock_model("Product", id: 29, inventory: 5)
      product_6 = mock_model("Product", id: 30, inventory: 6)
      products_array = [ product_1, product_2, product_3, product_4, product_5, product_6 ]
      subject.products = []
      subject.products = products_array

      subject.should_receive(:remove_color_variations).and_return(products_array)
      
      products_array.shift
      subject.suggestion_products.should eq(products_array.reverse)
    end
  end

end
