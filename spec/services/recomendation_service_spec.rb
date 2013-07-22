require "spec_helper"

describe RecomendationService do
  subject { described_class.new({ profiles: @profiles }) }
  before do
    @profiles = [FactoryGirl.create(:casual_profile)]
  end

  describe "#products" do
    context "when product quantity matters" do
      before do
        4.times do
          FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:shoe, name: "#shoe_#{ rand }", profiles: @profiles))
          FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:bag, name: "#bag_#{ rand }", profiles: @profiles))
          FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:basic_accessory, name: "#accessory_#{ rand }", profiles: @profiles))
        end
      end

      context 'and limit 10 was passed' do
        it { expect(subject.products(limit: 10).count).to eq(10) }
      end
      context 'and no limit was passed' do
        it { expect(subject.products.count).to eq(5) }
      end
    end

    context "when category matters" do
      let(:category_shoe) { Category::SHOE }
      let(:category_bag) { Category::BAG }
      let(:category_accessory) { Category::ACCESSORY }
      let(:category_cloth) { Category::CLOTH }

      before do
        @shoe = FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:shoe, name: "#shoe #{ rand }", profiles: @profiles)).product
        @bag = FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:bag, name: "#bag #{ rand }", profiles: @profiles)).product
        @accessory = FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:basic_accessory, name: "#accessory #{ rand }", profiles: @profiles)).product
        @cloth = FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:simple_garment, name: "#cloth #{ rand }", profiles: @profiles)).product
      end

      context 'and I want only shoes' do
        it { expect(subject.products(category: category_shoe)).to include(@shoe) }
        it { expect(subject.products(category: category_shoe)).to_not include(@bag) }
        it { expect(subject.products(category: category_shoe)).to_not include(@accessory) }
        it { expect(subject.products(category: category_shoe)).to_not include(@cloth) }
      end

      context 'and I want only bags' do
        it { expect(subject.products(category: category_bag)).to_not include(@shoe) }
        it { expect(subject.products(category: category_bag)).to include(@bag) }
        it { expect(subject.products(category: category_bag)).to_not include(@accessory) }
        it { expect(subject.products(category: category_bag)).to_not include(@cloth) }
      end

      context 'and I want only accessories' do
        it { expect(subject.products(category: category_accessory)).to_not include(@shoe) }
        it { expect(subject.products(category: category_accessory)).to_not include(@bag) }
        it { expect(subject.products(category: category_accessory)).to include(@accessory) }
        it { expect(subject.products(category: category_accessory)).to_not include(@cloth) }
      end

      context 'and I want only cloth' do
        it { expect(subject.products(category: category_cloth)).to_not include(@shoe) }
        it { expect(subject.products(category: category_cloth)).to_not include(@bag) }
        it { expect(subject.products(category: category_cloth)).to_not include(@accessory) }
        it { expect(subject.products(category: category_cloth)).to include(@cloth) }
      end
    end

    context "when has no category" do
      context "and I want products of all categories" do
        it { expect(subject.products(limit: 100)).to include(*@profiles.first.products)}
      end
    end

    context "when there's not enough products in main profile" do
      subject { described_class.new({ profiles: @profiles }).products(limit: 3) }

      before do
        @profiles << FactoryGirl.create(:sporty_profile)
        @products_returned = [FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:shoe, profiles: [@profiles.first])).product]
        @products_returned << FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:bag, profiles: [@profiles.last])).product
        @products_returned << FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:basic_accessory, profiles: [@profiles.last])).product
        @products_not_returned = FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:simple_garment, profiles: [@profiles.last])).product
      end

      context "returned products" do
        it { should include(*@products_returned) }
        it { should_not include(@products_not_returned) }
      end

      context "the first products should follow given profile's order" do
        it { expect(subject.first).to eq(@products_returned.first) }
      end
    end

    context "ordering profile's products by decreasing inventory" do
      subject { described_class.new({ profiles: @profiles }).products(limit: 4) }

      before do
        @profiles << FactoryGirl.create(:sporty_profile)

        @sec_product = FactoryGirl.create(:variant, inventory: 1, product: FactoryGirl.create(:shoe, profiles: [@profiles.first])).product
        @first_product = FactoryGirl.create(:variant, inventory: 8, product: FactoryGirl.create(:bag, profiles: [@profiles.first])).product
        @third_product = FactoryGirl.create(:variant, inventory: 9, product: FactoryGirl.create(:basic_accessory, profiles: [@profiles.last])).product
        @fourth_product = FactoryGirl.create(:variant, inventory: 3, product: FactoryGirl.create(:simple_garment, profiles: [@profiles.last])).product

      end

      it { expect(subject.first).to eq(@first_product) }
      it { expect(subject[1]).to eq(@sec_product) }
      it { expect(subject[2]).to eq(@third_product) }
      it { expect(subject[3]).to eq(@fourth_product) }
    end

    context "when product is sold out" do
      subject { described_class.new({ profiles: @profiles }).products(limit: 4) }

      before do
        @product = FactoryGirl.create(:variant, inventory: 0, product: FactoryGirl.create(:bag, profiles: [@profiles.first])).product
      end
      it { should_not include @product }
    end

    context "filtering by shoe size" do
      subject { described_class.new({ profiles: @profiles, shoe_size: "37" }).products }

      before do
        @product = FactoryGirl.create(:variant, inventory: 10, description: "37", product: FactoryGirl.create(:shoe, profiles: [@profiles.first])).product
        @sec_product = FactoryGirl.create(:variant, inventory: 10, description: "38", product: FactoryGirl.create(:shoe, profiles: [@profiles.first])).product
      end

      it { should include @product }
      it { should_not include @sec_product }

      context "when products is not a shoe" do
        before do
          @bag = FactoryGirl.create(:variant, inventory: 10, description: "Some Bag", product: FactoryGirl.create(:bag, profiles: [@profiles.first])).product
        end

        it { should include(@bag) }
      end
    end

    context 'filtering by collection' do
      subject { described_class.new( profiles: @profiles ).products( collection: @collection ) }

      before do
        @collection = FactoryGirl.create(:collection, :active)
        @product = FactoryGirl.create(:variant, inventory: 10, description: "37", product: FactoryGirl.create(:shoe, collection: @collection, profiles: [@profiles.first])).product
        @sec_product = FactoryGirl.create(:variant, inventory: 10, description: "38", product: FactoryGirl.create(:shoe, collection: FactoryGirl.create(:collection, :inactive), profiles: [@profiles.first])).product
      end

      it { should include @product }
      it { should_not include @sec_product }
    end

    context 'when the same product is being called twice' do
      before do
        @shoe = FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:shoe, name: "#shoe #{ rand }", profiles: @profiles)).product
        @bag = FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:bag, name: "#bag #{ rand }", profiles: @profiles)).product
        @accessory = FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:basic_accessory, name: "#accessory #{ rand }", profiles: @profiles)).product
        @cloth = FactoryGirl.create(:variant, :in_stock, product: FactoryGirl.create(:simple_garment, name: "#cloth #{ rand }", profiles: @profiles)).product
      end      
      it "includes unique product occurrences only" do
        described_class.any_instance.should_receive(:filtered_list_for_profile).and_return([@shoe, @shoe, @bag, @accessory, @cloth])

        described_class.new({ profiles: @profiles }).products.count(@shoe).should eq(1)
      end
    end
  end
end
