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
    expect {
      detail.product.destroy
    }.to change(described_class, :count).by(-1)
  end

  describe "scopes" do
    let!(:invisible_detail) { FactoryGirl.create(:invisible_detail) }
    let!(:specification_detail) { FactoryGirl.create(:heel_detail) }
    let!(:how_to_detail) { FactoryGirl.create(:how_to_detail) }

    describe "only_invisible scope" do
      it "should return only the details with display_on equal to invisible" do
        described_class.only_invisible.all.should == [invisible_detail]
      end
    end

    describe "only_specification scope" do
      it "should return only the details with display_on equal to specification" do
        described_class.only_specification.all.should == [specification_detail]
      end
    end

    describe "only_how_to scope" do
      it "should return only the details with display_on equal to how_to" do
        described_class.only_how_to.all.should == [how_to_detail]
      end
    end
    describe "without_specific_translations" do
      let!(:tip) { FactoryGirl.create(:tip) }
      let!(:keywords) { FactoryGirl.create(:keywords) }
      it "don't return tip translation_token" do
        expect(described_class.without_specific_translations.all).to_not include(tip)
      end
      it "don't return keywords translation_token" do
        expect(described_class.without_specific_translations.all).to_not include(keywords)
      end
    end
  end
end
