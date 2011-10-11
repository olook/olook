# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Picture do
  context "validation" do
    it { should validate_presence_of(:image) }
    it { should validate_presence_of(:product) }
    it { should belong_to(:product) }
  end

  describe "#display_on" do
    subject { FactoryGirl.create(:gallery_picture) }

    it "should save display_on in the DB as an integer based on the DisplayOn list" do
      subject.read_attribute(:display_on).should == Picture::DisplayOn[:gallery]
    end
    it "should retrieve display_on as a symbol based on the DisplayOn list" do
      subject.display_on.should == :gallery
    end
    it "should retrieve :none for a new object" do
      described_class.new.display_on.should == :none
    end
    it "should return :none if the display_on isn't defined on DisplayOn" do
      subject.display_on = :otherstuff
      subject.display_on.should == :none
    end    
  end
end
