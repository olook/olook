# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Variant do
  context "validation" do
    it { should validate_presence_of(:product) }
    it { should belong_to(:product) }

    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:display_reference) }

    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price) }

    it { should validate_presence_of(:inventory) }
    it { should validate_numericality_of(:inventory) }
  end
  
  subject { FactoryGirl.create(:basic_shoe_size_35) }
  
  it "the SKU should be the combination of product.model_number and the variant number" do
    subject.product.model_number = 'ABC-123'
    subject.number = '35A'
    subject.sku.should == 'ABC-123-35A'
  end

  it "should destroy the associated variants when the product is destroyed" do
    subject.should be_persisted
    Product.count.should == 1
    Variant.count.should == 1
    subject.product.destroy
    Product.count.should be_zero
    Variant.count.should be_zero
  end
end
