# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProductsHelper do
  describe "#share_description" do
    let(:shoe){FactoryGirl.build(:shoe, id: 1)}
    let(:bag){FactoryGirl.build(:bag, id: 1)}
    context "When dont need to have product link" do
      it "return message with 'o' letter" do
        expect(helper.share_description(shoe,false)).to eql("Vi o sapato #{shoe.name} no site da Olook e amei! <3")
      end
      it "return message with 'a' letter" do
        expect(helper.share_description(bag,false)).to eql("Vi a bolsa #{bag.name} no site da Olook e amei! <3")
      end
    end
    context "When need to have product link" do
      it "return message with 'o' letter" do
        expect(helper.share_description(shoe)).to eql("Vi o sapato #{shoe.name} no site da Olook e amei! <3 #{product_seo_url(shoe.seo_path)}")
      end
      it "return message with 'a' letter" do
        expect(helper.share_description(bag)).to eql("Vi a bolsa #{bag.name} no site da Olook e amei! <3 #{product_seo_url(bag.seo_path)}")
      end
    end
  end

  with_a_logged_user do
    let!(:user_info) { FactoryGirl.create(:user_info, user: user) }
    let(:not_size_variant) { FactoryGirl.create(:basic_shoe_size_37) }
    let(:sold_out_variant) { FactoryGirl.create(:basic_shoe_size_35, :inventory => 0) }
    let(:normal_variant) { FactoryGirl.create(:basic_shoe_size_35 ) }
    let(:product) { variant.product }
    
    it "should return a string with class unavailable" do
      helper.variant_classes( sold_out_variant ).should == "unavailable"
    end

    it "should return a string with selected class" do
      helper.variant_classes( normal_variant ).should == "selected"
    end

    it "should return a empty string" do
      helper.variant_classes( not_size_variant ).should == ""
    end

    it "should return a empty string when force size is zero" do
      helper.variant_classes( not_size_variant, 0 ).should == ""
    end
    
    it "should return a string with selected class when force size" do
      helper.variant_classes( not_size_variant, 37 ).should == "selected"
    end

    it "should return a empty string when force size" do
      helper.variant_classes( normal_variant, 37 ).should == ""
    end
    
  end
end
