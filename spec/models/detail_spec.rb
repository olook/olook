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
    described_class.count.should == 1
    detail.product.destroy
    Product.count.should be_zero
    described_class.count.should be_zero
  end
  
  describe "scopes" do
    let!(:invisible_detail) { FactoryGirl.create(:invisible_detail) }
    let!(:visible_detail) { FactoryGirl.create(:heel_detail) }

    describe "visible scope" do
      it "should return only the details with display_on attribute different from invisible" do
        described_class.visible.all.should include(visible_detail)
        described_class.visible.all.should_not include(invisible_detail)
      end
    end

    describe "invisible scope" do
      it "should return only the details with display_on equal to invisible" do
        described_class.invisible.all.should_not include(subject)
        described_class.invisible.all.should include(invisible_detail)
      end
    end
  end
end
