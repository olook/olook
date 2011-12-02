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
    it { should belong_to(:collection) }

    it { should have_and_belong_to_many(:profiles) }
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
    let(:unrelated_product) { FactoryGirl.create(:basic_shoe) }

    it "#related_products" do
      FactoryGirl.create(:related_product, :product_a => silver_slipper, :product_b => subject )
      subject.related_products.should include(silver_slipper)
    end

    it "#unrelated_products" do
      FactoryGirl.create(:related_product, :product_a => silver_slipper, :product_b => subject)
      subject.unrelated_products.should == [unrelated_product]
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
  
  describe "#master_variant" do
    subject { FactoryGirl.build(:basic_shoe) }

    it "newly initialized products should have a non-saved master variant instantiated" do
      subject.master_variant.should_not be_nil
      subject.master_variant.should_not be_persisted
    end

    it "should call save_master_variant after_save" do
      subject.should_receive(:save_master_variant)
      subject.save
    end

    it "should be created automaticaly after the product is created" do
      subject.save
      subject.master_variant.should_not be_nil
      subject.master_variant.should be_persisted
      subject.master_variant.description.should == 'master'
    end
  end
  
  describe "methods delegated to master_variant" do
    subject { FactoryGirl.create(:basic_shoe) }
    
    describe 'getter methods' do
      it "#price" do
        subject.master_variant.should_receive(:price)
        subject.price
      end

      it "#width" do
        subject.master_variant.should_receive(:width)
        subject.width
      end

      it "#height" do
        subject.master_variant.should_receive(:height)
        subject.height
      end

      it "#length" do
        subject.master_variant.should_receive(:length)
        subject.length
      end

      it "#weight" do
        subject.master_variant.should_receive(:weight)
        subject.weight
      end
    end

    describe 'setter methods' do
      it "#price=" do
        subject.price = 765.0
        subject.master_variant.price.should == 765.0
      end

      it "#width=" do
        subject.width = 55.0
        subject.master_variant.width.should == 55.0
      end

      it "#height=" do
        subject.height = 66.0
        subject.master_variant.height.should == 66.0
      end

      it "#length=" do
        subject.length = 77.0
        subject.master_variant.length.should == 77.0
      end

      it "#weight=" do
        subject.weight = 987.0
        subject.master_variant.weight.should == 987.0
      end
    end
  end
  
  describe "picture helpers" do
    describe "#showroom_picture" do
      it "should return the image if it exists" do
        mock_image = double :image
        mock_image.should_receive(:image_url).with(:showroom).and_return(:valid_image)
        subject.pictures.should_receive(:where).with(:display_on => DisplayPictureOn::GALLERY_1).and_return([mock_image])
        subject.showroom_picture.should == :valid_image
      end
      it "should return nil if it doesn't exist" do
        subject.pictures.should_receive(:where).with(:display_on => DisplayPictureOn::GALLERY_1).and_return([nil])
        subject.showroom_picture.should be_nil
      end
    end
  end
end
