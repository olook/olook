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

  end

  describe "#suggestion_products" do

    let(:product_1)   { FactoryGirl.build(:shoe, name: rand.to_s) }
    let(:product_2)   { FactoryGirl.build(:shoe, name: rand.to_s) }
    let(:product_3)   { FactoryGirl.build(:shoe, name: rand.to_s) }
    let(:product_4)   { FactoryGirl.build(:shoe, name: rand.to_s) }
    let(:product_5)   { FactoryGirl.build(:shoe, name: rand.to_s) }
    let(:product_6)   { FactoryGirl.build(:shoe, name: rand.to_s) }
    let(:all_products) { [product_1, product_2, product_3, product_4, product_5, product_6] }
    let(:products_inventory_desc) { [ product_6, product_5, product_4, product_3, product_2 ] }

    before do
      product_1.stub(:inventory).and_return(1)
      product_2.stub(:inventory).and_return(2)
      product_3.stub(:inventory).and_return(3)
      product_4.stub(:inventory).and_return(4)
      product_5.stub(:inventory).and_return(5)
      product_6.stub(:inventory).and_return(6)

      subject.stub(:products).and_return(all_products)
    end

    it "receives method remove_color_variations" do
      subject.should_receive(:remove_color_variations).and_return(products_inventory_desc)
      subject.suggestion_products
    end


    it "returns 5 products ordering by inventory desc" do
      expect(subject.suggestion_products).to eq(products_inventory_desc)
    end
  end

end
