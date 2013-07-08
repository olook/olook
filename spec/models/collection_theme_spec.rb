require 'spec_helper'

describe CollectionTheme do
  let(:collection_theme) { FactoryGirl.create(:collection_theme) }
  let(:day_by_day) { FactoryGirl.build(:collection_theme) }

  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
    it { collection_theme.should validate_uniqueness_of(:slug) }
    it { should have_one(:catalog) }
  end

  describe "association" do
    it { should have_and_belong_to_many(:products) }
  end

  describe "default" do
    it { CollectionTheme.new.active.should be_false }
    it { expect(CollectionTheme.new(name: 'Super teste').slug).to eql('super-teste') }
  end

  describe "after create" do
    it "generate catalog" do
      day_by_day.catalog.should be_blank
      day_by_day.save!
      day_by_day.catalog.should_not be_nil
      day_by_day.catalog.should == Catalog::CollectionTheme.last
    end
  end

  describe '#video_id' do
    context 'when video_link nil' do
      subject { CollectionTheme.new(video_link: nil).video_id }
      it { should == nil }
    end

    context 'when video_link filled' do
      subject { CollectionTheme.new(video_link: 'http://www.youtube.com/watch?v=1tCr23eZ7Vo&list=UUjPbOLQD7X5ef0T29IkkXzQ').video_id }
      it { should == '1tCr23eZ7Vo' }
    end

    context 'when video_link filled with embed link' do
      subject { CollectionTheme.new(video_link: 'http://www.youtube.com/embed/1tCr23eZ7Vo?list=UUjPbOLQD7X5ef0T29IkkXzQ').video_id }
      it { should == '1tCr23eZ7Vo' }
    end
  end

  describe '#video_options' do
    context 'when video_link nil' do
      subject { CollectionTheme.new(video_link: nil).video_options }
      it { should == { } }
    end

    context 'when video_link filled' do
      subject { CollectionTheme.new(video_link: 'http://www.youtube.com/watch?v=1tCr23eZ7Vo&list=UUjPbOLQD7X5ef0T29IkkXzQ').video_options }
      it { should == { 'list' => 'UUjPbOLQD7X5ef0T29IkkXzQ' } }
    end

    context 'when video_link filled with embed link' do
      subject { CollectionTheme.new(video_link: 'http://www.youtube.com/embed/1tCr23eZ7Vo?list=UUjPbOLQD7X5ef0T29IkkXzQ').video_options }
      it { should == { 'list' => 'UUjPbOLQD7X5ef0T29IkkXzQ' } }
    end
  end

  describe "#product_associate_ids=" do
    let(:product1) {FactoryGirl.create(:shoe)}
    let(:product2) {FactoryGirl.create(:shoe)}
    let(:product3) {FactoryGirl.create(:shoe)}
    let!(:basic_shoe_size_35) { FactoryGirl.create :basic_shoe_size_35, :product => product1 }
    let!(:basic_shoe_size_40) { FactoryGirl.create :basic_shoe_size_40, :product => product2 }
    let!(:basic_shoe_size_37) { FactoryGirl.create :basic_shoe_size_37, :product => product3 }
    context "when dont have products" do
      it "associate ids" do
        subject.product_associate_ids = "#{product1.id} #{product2.id} #{product3.id}"
        expect(subject.products.size).to eql(3)
      end
    end
    context "when already have products" do
      before do
        subject.product_associate_ids = "#{product1.id}"
        subject.product_associate_ids = "#{product2.id} #{product3.id}"
      end
      it "make new associations" do
        expect(subject.product_ids).to include(product2.id, product3.id)
      end

      it "remove old association" do
        expect(subject.product_ids).to_not include(product1.id)
      end
    end
  end
  describe "#sanitize_products" do
    let!(:product) {FactoryGirl.create(:shoe)}

    it "returns hash" do
      expect(subject.sanitize_products(Hash.new)).to be_kind_of(Hash)
    end

    context "When dont find products" do
      it "returns product id on not_found key" do
        Product.should_receive(:find_by_id).and_return(nil)
        product_hash = subject.sanitize_products([product.id])
        expect(product_hash.fetch(:not_found)).to eql([product.id])
      end
    end
    context "When product dont have inventory" do
      it "returns product id on not_inventory key" do
        product_hash = subject.sanitize_products([product.id])
        expect(product_hash.fetch(:not_inventory)).to eql([product.id])
      end
    end
    context "When product is not visible" do
      it "returns product id on not_visible key" do
        product.update_attributes(is_visible: false)
        product_hash = subject.sanitize_products([product.id])
        expect(product_hash.fetch(:not_visible)).to eql([product.id])
      end
    end
    context "When product is avaliable" do
      it "returns product id on successful key" do
        Product.any_instance.should_receive(:inventory).and_return(2)
        product_hash = subject.sanitize_products([product.id])
        expect(product_hash.fetch(:successful)).to eql([product.id])
      end
    end
  end
end
