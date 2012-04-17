require "spec_helper"

describe ProductFinderService do

  let!(:user) { Factory.create(:user) }
  subject { ProductFinderService.new user}

  let!(:casual_profile) { FactoryGirl.create(:casual_profile) }
  let!(:sporty_profile) { FactoryGirl.create(:sporty_profile) }
  let(:collection) { FactoryGirl.create(:collection) }
  let!(:product_a) { FactoryGirl.create(:blue_slipper, :name => 'A', :collection => collection, :profiles => [casual_profile]) }
  let!(:product_b) { FactoryGirl.create(:blue_slipper, :name => 'B', :collection => collection, :profiles => [casual_profile]) }
  let!(:product_c) { FactoryGirl.create(:blue_slipper, :name => 'C', :collection => collection, :profiles => [sporty_profile], :category => Category::BAG) }
  let!(:product_d) { FactoryGirl.create(:blue_slipper, :name => 'D', :collection => collection, :profiles => [casual_profile, sporty_profile]) }
  let!(:product_e) { FactoryGirl.create(:blue_slipper, :name => 'E', :collection => collection, :profiles => [casual_profile, sporty_profile]) }
  let!(:variant_product_e) { FactoryGirl.create(:basic_shoe_size_35, :product => product_e, :inventory => 0) }

  let!(:product_f) { FactoryGirl.create(:blue_slipper, :name => 'F', :collection => collection, :profiles => [casual_profile, sporty_profile]) }
  let!(:variant_product_f) { FactoryGirl.create(:basic_shoe_size_37, :product => product_f, :inventory => 1) }

  let!(:product_g) { FactoryGirl.create(:basic_accessory, :name => 'G', :collection => collection, :profiles => [sporty_profile], :category => Category::ACCESSORY) }

  let!(:invisible_product) { FactoryGirl.create(:blue_slipper, :is_visible => false, :collection => collection, :profiles => [sporty_profile]) }
  let!(:casual_points) { FactoryGirl.create(:point, user: user, profile: casual_profile, value: 10) }
  let!(:sporty_points) { FactoryGirl.create(:point, user: user, profile: sporty_profile, value: 40) }

  before :each do
    Collection.stub(:current).and_return(collection)
  end

  describe "#showroom_products" do
    it "should return the products ordered by profiles without duplicate names" do
      subject.showroom_products.should == [product_d, product_e, product_f, product_a, product_b, product_c, product_g]
    end

    it 'should return only the products of a given category' do
      subject.showroom_products(Category::BAG).should == [product_c]
    end

    it 'should return an array' do
      subject.showroom_products.should be_a(Array)
    end
  end

  describe "#products_from_all_profiles" do
    it "should return the products ordered by profiles without duplicate names" do
      subject.products_from_all_profiles(nil).should == [product_c, product_d, product_e, product_f, product_g, product_a, product_b]
    end

    it "should return the products ordered by profiles without duplicate names" do
      subject.products_from_all_profiles(nil, "37").should == [product_f]
    end

    it 'should return only products of the specified category' do
      subject.products_from_all_profiles(Category::BAG).should == [product_c]
    end

    it 'should return an array' do
      subject.products_from_all_profiles(nil).should be_a(Array)
    end
  end

  describe "#profile_products" do
    it "should return only the products for the given profile" do
      subject.profile_products(sporty_profile).should == [product_c, product_d, product_e, product_f, product_g]
    end

    it "should return only the products for the given profile" do
      subject.profile_products(sporty_profile, nil, "37").should == [product_f]
    end

    it 'should return only the products for the given profile and category' do
      subject.profile_products(sporty_profile, Category::BAG).should == [product_c]
    end

    it 'should not include the invisible product' do
      subject.profile_products(sporty_profile).should_not include(invisible_product)
    end
  end
end
