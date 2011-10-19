# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Product do
  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:model_number) }
    it { should have_many(:pictures) }
    it { should have_many(:details) }
    it { should have_many(:variants) }
  end

  describe "scopes" do
    before :each do
      @shoe  = FactoryGirl.create(:basic_shoe)
      @bag   = FactoryGirl.create(:basic_bag)
      @jewel = FactoryGirl.create(:basic_jewel)
      described_class.count.should == 3
    end

    it "the shoes scope should return only shoes" do
      described_class.shoes.should == [@shoe]
    end
    it "the bags scope should return only bags" do
      described_class.bags.should == [@bag]
    end
    it "the jewels scope should return only jewels" do
      described_class.jewels.should == [@jewel]
    end
  end
  
  describe 'when working with related products' do
    subject { FactoryGirl.create(:red_slipper) }
    let(:silver_slipper) { FactoryGirl.create(:silver_slipper) }

    it "#related_products" do
      FactoryGirl.create(:related_product, :product_a => silver_slipper, :product_b => subject )
      subject.related_products.should include(silver_slipper)
    end

    describe "#is_related_to?" do
      before :each do
        FactoryGirl.create(:related_product, :product_a => silver_slipper, :product_b => subject )
      end

      it "should return true when the relationship exists" do
        subject.is_related_to?(silver_slipper).should be_true
      end
      it "should return false when the relationship doesn't exists" do
        subject.is_related_to?(subject).should be_false
      end
    end

    it "#relate_with_product" do
      subject.relate_with_product(silver_slipper)
      subject.related_products.should include(silver_slipper)
    end
  end
end
