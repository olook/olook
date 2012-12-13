require 'spec_helper'

describe FreebieVariant do
  
  context "attributes validation" do
    it { should validate_presence_of(:variant_id) }
    it { should validate_presence_of(:freebie_id) }

  end

  context "when setting freebie" do

    let(:shoe_freebie) {FactoryGirl.create(:basic_shoe_size_35)}
    let(:bag_freebie) {FactoryGirl.create(:basic_bag_normal, :product => FactoryGirl.create(:basic_bag))}
    let(:accessory_freebie) {FactoryGirl.create(:basic_accessory_simple, :product => FactoryGirl.create(:basic_accessory))}
    let(:freebie_variant) {FreebieVariant.new({:variant => FactoryGirl.create(:basic_bag_simple)})}

    it "should not accept shoe" do
      freebie_variant.freebie = shoe_freebie
      freebie_variant.should be_invalid
    end

    it "should accept bag" do
      freebie_variant.freebie = bag_freebie
      freebie_variant.should be_valid
    end

    it "should accept accessory" do
      freebie_variant.freebie = accessory_freebie
      freebie_variant.should be_valid
    end

  end



end
