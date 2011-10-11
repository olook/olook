# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Product do
  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should have_many(:pictures) }
  end

  describe "category" do
    subject { FactoryGirl.create(:basic_shoe) }

    it "should save category in the DB as an integer based on the Categories list" do
      subject.read_attribute(:category).should == Product::Categories[:shoe]
    end
    it "should retrieve category as a symbol based on the Categories list" do
      subject.category.should == :shoe
    end
    it "should retrieve :none for a new object" do
      described_class.new.category.should == :none
    end
    it "should return :none if the categories isn't defined on Categories" do
      subject.category = :otherstuff
      subject.category.should == :none
    end    
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
