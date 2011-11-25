# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Variant do
  context "validation" do
    it { should validate_presence_of(:product) }
    it { should belong_to(:product) }

    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:display_reference) }

    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price) }

    it { should validate_presence_of(:inventory) }
    it { should validate_numericality_of(:inventory) }

    it { should validate_presence_of(:width) }
    it { should validate_numericality_of(:width) }

    it { should validate_presence_of(:height) }
    it { should validate_numericality_of(:height) }

    it { should validate_presence_of(:length) }
    it { should validate_numericality_of(:length) }

    it { should validate_presence_of(:weight) }
    it { should validate_numericality_of(:weight) }
  end

  subject { FactoryGirl.create(:basic_shoe_size_35) }

  describe "#sku" do
    it "should be the combination of product.model_number and the variant number" do
      subject.product.model_number = 'ABC-123'
      subject.number = '35A'
      subject.sku.should == 'ABC-123-35A'
    end
  end

  it "should destroy the associated variants when the product is destroyed" do
    subject.should be_persisted
    Product.count.should == 1
    Variant.count.should == 1
    subject.product.destroy
    Product.count.should be_zero
    Variant.count.should be_zero
  end

  describe "dimension related methods" do
    before :each do
      subject.stub(:width).and_return(10.1)
      subject.stub(:height).and_return(20.1)
      subject.stub(:length).and_return(30.1)
    end

    describe "#dimensions" do
      it "should concatenate all the variant dimensions" do
        subject.dimensions.should == '10,1x20,1x30,1 cm'
      end
    end

    describe "#volume" do
      it "should return the volume in cubic meters" do
        subject.volume.should == ((10.1*20.1*30.1)/1000000).round(6)
      end
    end
  end

  describe "before_save fill is_master" do
    subject { FactoryGirl.build(:basic_shoe_size_35, :is_master => nil) }

    it "should call fill_is master" do
      subject.should_receive(:fill_is_master)
      subject.save
    end

    it "should force the value to false" do
      subject.is_master.should be_nil
      subject.save
      subject.is_master.should == false
    end
  end
end

