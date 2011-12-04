# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Picture do
  context "validation" do
    it { should validate_presence_of(:product) }
    it { should belong_to(:product) }
  end
  
  it "should destroy the associated picture when the product is destroyed" do
    picture = FactoryGirl.create(:main_picture)
    Product.count.should == 1
    Picture.count.should == 1
    picture.product.destroy
    Product.count.should be_zero
    Picture.count.should be_zero
  end
end
