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
    let!(:shoe)      { FactoryGirl.create(:basic_shoe) }
    let!(:bag)       { FactoryGirl.create(:basic_bag) }
    let!(:accessory) { FactoryGirl.create(:basic_accessory) }
    let!(:invisible_shoe) { FactoryGirl.create(:basic_shoe, :is_visible => false) }

    before :each do
      described_class.count.should == 4
    end

    it "the shoes scope should return only shoes" do
      described_class.shoes.should == [shoe, invisible_shoe]
    end
    it "the bags scope should return only bags" do
      described_class.bags.should == [bag]
    end
    it "the accessories scope should return only accessories" do
      described_class.accessories.should == [accessory]
    end
    it 'the visible scope should not return invisible products' do
      described_class.only_visible.should == [shoe, bag, accessory]
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

    it "newly initialized products should return nil" do
      subject.master_variant.should be_nil
    end

    it "should call create_master_variant after_saving a new product" do
      subject.should_receive(:create_master_variant)
      subject.save
    end

    it "should call update_master_variant after_saving a change in the product" do
      subject.save
      subject.price = 10
      subject.should_receive(:update_master_variant)
      subject.save
    end

    it "should be created automaticaly after the product is created" do
      subject.save
      subject.master_variant.should_not be_nil
      subject.master_variant.should be_persisted
      subject.master_variant.description.should == 'master'
    end

    describe 'helper methods' do
      it '#create_master_variant' do
        new_variant = double :variant
        new_variant.should_receive(:'save!')
        Variant.should_receive(:new).and_return(new_variant)
        subject.instance_variable_get('@master_variant').should be_nil
        subject.send :create_master_variant
        subject.instance_variable_get('@master_variant').should == new_variant
      end

      describe '#update_master_variant' do
        before :each do
          subject.save # create product
          subject.description = 'a'
        end

        it 'should trigger the method after_update' do
          subject.should_receive(:update_master_variant)
          subject.save
        end

        it 'should call save on the master variant' do
          subject.master_variant.should_receive(:'save!')
          subject.save
        end

        it 'fix bug: should not break if @master_variant was not initialized' do
          loaded_product = Product.find subject.id
          expect {
            loaded_product.save
          }.not_to raise_error
        end
      end
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
    let(:mock_picture) { double :picture }

    describe '#main_picture' do
      let!(:some_picture) { FactoryGirl.create(:picture, :product => subject, :display_on => DisplayPictureOn::GALLERY_3) }
      let!(:main_picture) { FactoryGirl.create(:main_picture, :product => subject) }

      it 'should return the picture to be displayed as Gallery 1' do
        subject.main_picture.should == main_picture
      end
    end

    describe "#showroom_picture" do
      it "should return the showroom sized image if it exists" do
        mock_picture.stub(:image_url).with(:showroom).and_return(:valid_image)
        subject.stub(:main_picture).and_return(mock_picture)
        subject.showroom_picture.should == :valid_image
      end
      it "should return nil if it doesn't exist" do
        subject.showroom_picture.should be_nil
      end
    end

    describe '#thumb_picture' do
      it "should return the thumb sized image if it exists" do
        mock_picture.stub(:image_url).with(:thumb).and_return(:valid_image)
        subject.stub(:main_picture).and_return(mock_picture)
        subject.thumb_picture.should == :valid_image
      end
      it "should return nil if it doesn't exist" do
        subject.thumb_picture.should be_nil
      end
    end

    describe '#suggestion_picture' do
      it "should return the suggestion sized image if it exists" do
        mock_picture.stub(:image_url).with(:suggestion).and_return(:valid_image)
        subject.stub(:main_picture).and_return(mock_picture)
        subject.suggestion_picture.should == :valid_image
      end
      it "should return nil if it doesn't exist" do
        subject.suggestion_picture.should be_nil
      end
    end
  end

  describe '#variants.sorted_by_description' do
    subject { FactoryGirl.create(:basic_shoe) }
    let!(:last_variant) { FactoryGirl.create(:variant, :product => subject, :description => '36') }
    let!(:first_variant) { FactoryGirl.create(:variant, :product => subject, :description => '35') }

    it 'should return the variants sorted by description' do
      subject.variants.should == [last_variant, first_variant]
      subject.variants.sorted_by_description.should == [first_variant, last_variant]
    end
  end

  describe "#colors" do
    let(:black_shoe) { FactoryGirl.create(:basic_shoe, :color_name => 'black', :color_sample => 'black_sample') }
    let(:red_shoe) { FactoryGirl.create(:basic_shoe, :color_name => 'red', :color_sample => 'red_sample') }
    let(:black_bag) { FactoryGirl.create(:basic_bag) }

    before :each do
      black_shoe.relate_with_product black_bag
      black_shoe.relate_with_product red_shoe
    end

    it 'should return a hash list of related products of the same category of the product' do
      black_shoe.colors.should == [red_shoe]
    end
  end

  describe "#easy_to_find_description" do
    subject { FactoryGirl.build(:basic_bag,
                                :model_number => 'M123',
                                :name         => 'Fake product',
                                :color_name   => 'Black') }

    it 'should return a string with the model_number, name, color and humanized category' do
      subject.easy_to_find_description.should == 'M123 - Fake product - Black - Bag'
    end
  end

  describe 'inventory related methods' do
    subject { FactoryGirl.create :basic_shoe }
    let!(:basic_shoe_size_35) { FactoryGirl.create :basic_shoe_size_35, :product => subject }
    let!(:basic_shoe_size_40) { FactoryGirl.create :basic_shoe_size_40, :product => subject }

    describe '#inventory' do
      it "should return the sum of the variants inventory" do
        basic_shoe_size_35.update_attributes(:inventory => 3)
        basic_shoe_size_40.update_attributes(:inventory => 1)
        subject.inventory.should == 4
      end
    end

    describe '#sold_out?' do
      it "should return false if any of the variants is available" do
        subject.stub(:inventory).and_return(2)
        subject.should_not be_sold_out
      end
      it "should return true if none of the variants is available" do
        subject.stub(:inventory).and_return(0)
        subject.should be_sold_out
      end
    end
  end

  describe "#instock" do
    it "returns 1 when product is in stock" do
      subject.stub(:inventory).and_return(1)
      subject.instock.should == "1"
    end

    it "returns 1 when product is in stock" do
      subject.stub(:inventory).and_return(0)
      subject.instock.should == "0"
    end
  end

  describe "#to_xml" do
    subject { FactoryGirl.create(:basic_shoe) }

    let(:xml_body) do
      <<-END.gsub(/^ {6}/, '')
      <product id="#{subject.id}">
        <name>Chanelle</name>
        <smallimage></smallimage>
        <bigimage></bigimage>
        <producturl>http://www.olook.com.br/produto/#{subject.id}?utm_campaign=remessaging&amp;utm_content=#{subject.id}&amp;utm_medium=banner&amp;utm_sorce=criteo</producturl>
        <description>Elegant black high-heeled shoe for executives</description>
        <price>0.0</price>
        <retailprice>0.0</retailprice>
        <recommendable>1</recommendable>
        <instock>0</instock>
        <category1>1</category1>
      </product>
      END
    end

    it "returns xml with all the necessary fields for criteo" do
      subject.to_xml.should == xml_body
    end
  end

end
