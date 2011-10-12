# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Product do
  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should have_many(:pictures) }
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
end
