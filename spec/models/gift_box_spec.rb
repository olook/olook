require 'spec_helper'

describe GiftBox do

  let!(:product_a) { FactoryGirl.create(:basic_shoe) }
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
=begin
    let(:product_1) { FactoryGirl.create(:basic_shoe) } #.stub(:inventory).and_return(6) }
    let(:product_2) { FactoryGirl.create(:basic_bag) } #.stub(:inventory).and_return(5) }
    let(:product_3) { FactoryGirl.create(:basic_accessory) } #.stub(:inventory).and_return(1) }
    let(:product_4) { FactoryGirl.create(:basic_shoe) } #.stub(:inventory).and_return(4) }
    let(:product_5) { FactoryGirl.create(:basic_bag) } #.stub(:inventory).and_return(2) }
    let(:product_6) { FactoryGirl.create(:basic_accessory) } #.stub(:inventory).and_return(3) }

    product_1.stub(:inventory).and_return(1)
    product_2.stub(:inventory).and_return(2)
    product_3.stub(:inventory).and_return(3)
    product_4.stub(:inventory).and_return(4)
    product_5.stub(:inventory).and_return(5)
    product_6.stub(:inventory).and_return(6)
    #product_1 = Product.any_instance.stub(id: 25, inventory: 2)
=end
    it "should return 5 products ordering by inventory" do
      pending
=begin
      binding.pry
      product_1 = mock_model("Product", id: 25, inventory: 1)
      product_2 = mock_model("Product", id: 26, inventory: 2)
      product_3 = mock_model("Product", id: 27, inventory: 3)
      product_4 = mock_model("Product", id: 28, inventory: 4)
      product_5 = mock_model("Product", id: 29, inventory: 5)
      product_6 = mock_model("Product", id: 30, inventory: 6)
      binding.pry
      products_array = [ product_1, product_2, product_3, product_4, product_5, product_6 ]
      subject.products = []
      subject.products = products_array
      binding.pry
      subject.suggestion_products.should eq(products_array.delete(product_3))
=end
    end
  end

end
