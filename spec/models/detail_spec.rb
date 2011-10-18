# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Detail do
  context "validation" do
    it { should validate_presence_of(:product) }
    it { should belong_to(:product) }
    it { should validate_presence_of(:translation_token) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:display_on) }
  end
  
  it "should destroy the associated details when the product is destroyed" do
    detail = FactoryGirl.create(:heel_detail)
    Product.count.should == 1
    Detail.count.should == 1
    detail.product.destroy
    Product.count.should be_zero
    Detail.count.should be_zero
  end
end
