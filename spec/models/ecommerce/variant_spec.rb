# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Variant do
  context "validation" do
    it { should validate_presence_of(:product) }
    it { should belong_to(:product) }

    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:display_reference) }

    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price) }

    it { should validate_presence_of(:inventory) }
    it { should validate_numericality_of(:inventory) }

    it { should validate_presence_of(:initial_inventory) }
    it { should validate_numericality_of(:initial_inventory) }

    it { should validate_presence_of(:width) }
    it { should validate_numericality_of(:width) }

    it { should validate_presence_of(:height) }
    it { should validate_numericality_of(:height) }

    it { should validate_presence_of(:length) }
    it { should validate_numericality_of(:length) }

    it { should validate_presence_of(:weight) }
    it { should validate_numericality_of(:weight) }
  end

  let(:product) { FactoryGirl.create(:shoe, :casual) }
  subject { FactoryGirl.create(:basic_shoe_size_35, :product => product) }

  describe "#update_initial_inventory_if_needed" do

    let(:variant) { FactoryGirl.create(:variant) }

    it "should increase initial_inventory because initial_inventory is 0" do
      variant.inventory = 80
      variant.update_initial_inventory_if_needed
      variant.initial_inventory.should == 80
    end

    it "should not increase initial_inventory because initial_inventory is not 0" do
      variant.inventory = 80
      variant.update_initial_inventory_if_needed
      variant.initial_inventory.should == 80

      variant.inventory = 50
      variant.update_initial_inventory_if_needed
      variant.initial_inventory.should == 80
    end

    it "should increase initial_inventory because inventory is greater than initial_inventory" do
      variant.inventory = 80
      variant.update_initial_inventory_if_needed
      variant.initial_inventory.should == 80

      variant.inventory = 150
      variant.update_initial_inventory_if_needed
      variant.initial_inventory.should == 150
    end

  end

  describe "#sku" do
    it "should be the combination of product.model_number and the variant number" do
      subject.product.model_number = 'ABC-123'
      subject.number = '35A'
      subject.sku.should == 'ABC-123-35A'
    end
  end

  it "should destroy the associated variants when the product is destroyed" do
    subject.should be_persisted
    variants_count = subject.product.variants.count
    expect {
      subject.product.destroy
    }.to change(Variant, :count).by(-variants_count)
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

  it "#master_variant" do
    subject.master_variant.should == subject.product.master_variant
  end

  describe "#copy_master_variant" do
    context "should call the method when a product_id is assigned" do
      it 'on build' do
        subject # load the subject before setting the expectation to avoid duplicate calls
        described_class.any_instance.should_receive(:copy_master_variant)
        new_variant = subject.product.variants.build
      end
      it 'when attributing product_id' do
        new_variant = FactoryGirl.create(:variant, :product => subject.product)
        new_variant.should_receive(:copy_master_variant)
        new_variant.product_id = subject.product.id
      end
    end

    describe 'when executing' do
      let(:new_variant) { subject.product.variants.build }

      it "should copy the master_variant attributes" do
        new_variant.copy_master_variant

        new_variant.width.should      == new_variant.master_variant.width
        new_variant.height.should     == new_variant.master_variant.height
        new_variant.length.should     == new_variant.master_variant.length
        new_variant.weight.should     == new_variant.master_variant.weight
        new_variant.price.should      == new_variant.master_variant.price

        new_variant.inventory.should  == 0
      end

      it "should not override the inventory" do
        new_variant.master_variant.stub(:inventory).and_return(123)
        new_variant.inventory = 456
        new_variant.copy_master_variant
        new_variant.inventory.should == 456
      end

      it "should return without doing anything if the variant being changed is the master itself" do
        subject.stub(:'is_master?').and_return(true)
        subject.should_not_receive(:'width=')
        subject.copy_master_variant
      end
    end

    it "should be called on the child variants when the master is updated" do
      subject.weight.should_not == 42
      subject.master_variant.weight = 42
      subject.master_variant.save
      subject.reload
      subject.weight.should == 42
    end
  end

  describe "delegated methods" do
    describe "#main_picture" do
      it "should return the product's main picture" do
        subject.product.stub(:main_picture).and_return(:main)
        subject.main_picture.should == :main
      end
    end
    describe "#showroom_picture" do
      it "should return the product's thumb picture" do
        subject.product.stub(:showroom_picture).and_return(:showroom)
        subject.showroom_picture.should == :showroom
      end
    end
    describe "#thumb_picture" do
      it "should return the product's thumb picture" do
        subject.product.stub(:thumb_picture).and_return(:thumb)
        subject.thumb_picture.should == :thumb
      end
    end
    describe "#color_name" do
      it "should return the product's color" do
        subject.product.stub(:color_name).and_return(:color)
        subject.color_name.should == :color
      end
    end
  end

  describe "inventory changes updates the catalog product" do
    let(:catalog) do
      moment  = FactoryGirl.create :collection_theme
      moment.catalog
    end

    let(:basic_bag) do
      product = (FactoryGirl.create :bag_subcategory_name).product
      product.master_variant.price = 100.00
      product.master_variant.save!

      FactoryGirl.create :basic_bag_simple, :product => product

      product
    end
  end

  describe "consolidate discount percent when has retail_price" do
    it "should round discount percent to 19" do
      variant = subject
      variant.price = 123.45
      variant.retail_price = 99.38
      variant.save!
      variant.discount_percent.should eq(19)
    end

    it "should round discount percent to 20" do
      variant = subject
      variant.price = 123.45
      variant.retail_price = 99.37
      variant.save!
      variant.discount_percent.should eq(20)
    end

    it "should handle when price is 0" do
      variant = subject
      variant.price = 0
      variant.retail_price = 99.99
      variant.save!
      variant.discount_percent.should eq(0)
    end

    it "should handle when retail price is 0" do
      variant = subject
      variant.price = 100
      variant.retail_price = 0
      variant.save!
      variant.discount_percent.should eq(0)
    end

    it "should handle when retail price is nil" do
      variant = subject
      variant.price = 100
      variant.retail_price = nil
      variant.save!
      variant.discount_percent.should eq(0)
    end
  end

  describe "#retail_price" do
    it "should return the retail price" do
      subject.retail_price = 99.99
      subject.save!
      subject.retail_price.should == 99.99
    end

    it "should return the original when the retail price is 0" do
      subject.retail_price = 0
      subject.save!
      subject.retail_price.should == 123.45
    end

    it "should return the original when the retail price is nil" do
      subject.retail_price = nil
      subject.save!
      subject.retail_price.should == 123.45
    end
  end

  describe "#discount_percent" do
    it "should return 0 when has no retail_price" do
      variant = Variant.new
      variant.stub(:liquidation?).and_return(false)
      variant.discount_percent.should == 0
    end

    it "should return the discount_percent when has retail_price" do
      subject.retail_price = 99.99
      subject.save!
      subject.discount_percent.should == 19
    end

    it "should return 0 when the retail_price price is 0" do
      subject.retail_price = 0
      subject.save!
      subject.discount_percent.should == 0
    end

    it "should return 0 when the retail_price is nil" do
      subject.retail_price = nil
      subject.save!
      subject.discount_percent.should == 0
    end
  end
end
