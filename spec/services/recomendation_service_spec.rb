require "spec_helper"

describe RecomendationService do
  subject { described_class.new({ profile: @profile }) }
  before do
    @profile = FactoryGirl.create(:casual_profile)
  end

  describe "#products" do
    #it { expect(subject.products(category_shoe)).to include(shoe) }
    #it { expect(subject.products(category_shoe)).to_not include(bag) }
    #it { expect(subject.products(category_shoe)).to_not include(accessory) }
    context "when product quantity matters" do
      before do
        4.times do
          FactoryGirl.create(:shoe, profiles: [@profile])
          FactoryGirl.create(:bag, profiles: [@profile])
          FactoryGirl.create(:basic_accessory, profiles: [@profile])
        end
        collection = @profile.products.first.collection
        Collection.stub(:current).and_return(collection)
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
        @shoe = FactoryGirl.create(:shoe, profiles: [@profile])
        @bag = FactoryGirl.create(:bag, profiles: [@profile])
        @accessory = FactoryGirl.create(:basic_accessory, profiles: [@profile])
        @cloth = FactoryGirl.create(:simple_garment, profiles: [@profile])
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
        it { expect(subject.products(limit: 100)).to include(*@profile.products)}
      end
    end
  end

end
