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
end
