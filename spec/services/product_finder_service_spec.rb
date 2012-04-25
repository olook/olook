require "spec_helper"

describe ProductFinderService do

  let!(:user) { Factory.create(:user) }
  subject { ProductFinderService.new user}

  let!(:casual_profile) { FactoryGirl.create(:casual_profile) }
  let!(:sporty_profile) { FactoryGirl.create(:sporty_profile) }
  let!(:collection) { FactoryGirl.create(:collection) }
  let!(:last_collection) { FactoryGirl.create(:collection, :start_date => 1.month.ago, :end_date => Date.today, :is_active => false) }
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
      subject.showroom_products(:not_allow_sold_out_products => true).should == [product_d, product_e, product_f, product_a, product_b]
    end

    it 'should return only the products of a given category' do
      subject.showroom_products(:category => Category::BAG).should == [product_c]
    end

    it 'should return an array' do
      subject.showroom_products.should be_a(Array)
    end
  end

  describe "#products_from_all_profiles" do
    it "should return the products ordered by profiles without duplicate names" do
      subject.products_from_all_profiles.should == [product_c, product_d, product_e, product_f, product_g, product_a, product_b]
    end

    it "should return the products ordered by profiles without duplicate names" do
      subject.products_from_all_profiles(:description => "37").should == [product_f]
    end

    it 'should return only products of the specified category' do
      subject.products_from_all_profiles(:category => Category::BAG).should == [product_c]
    end

    it 'should return an array' do
      subject.products_from_all_profiles.should be_a(Array)
    end
  end

  describe "#profile_products" do
    it "should return only the products for the given profile" do
      subject.profile_products(:profile => sporty_profile).should == [product_c, product_d, product_e, product_f, product_g]
    end

    it "should return only the products for the given profile" do
      product_c.update_attributes(:collection => last_collection)
      subject.profile_products(:profile => sporty_profile, :collection => last_collection).should == [product_c]
    end

    it "should return only the products for the given profile" do
      subject.profile_products(:profile => sporty_profile, :description => "37").should == [product_f]
    end

    it 'should return only the products for the given profile and category' do
      subject.profile_products(:profile => sporty_profile, :category => Category::BAG).should == [product_c]
    end

    it 'should not return sold out products' do
      FactoryGirl.create(:basic_bag_simple, :product => product_c, :inventory => 0)
      subject.profile_products(:profile => sporty_profile, :category => Category::BAG, :not_allow_sold_out_products => true).should_not == [product_c]
    end

    it 'should return a product if at least one variant has inventory grater than 0' do
      FactoryGirl.create(:basic_bag_simple, :product => product_c, :inventory => 0)
      FactoryGirl.create(:basic_bag_normal, :product => product_c, :inventory => 1)
      subject.profile_products(:profile => sporty_profile, :category => Category::BAG, :not_allow_sold_out_products => true).should == [product_c]
    end

    it 'should not include the invisible product' do
      subject.profile_products(:profile => sporty_profile).should_not include(invisible_product)
    end
  end

  describe '#suggested_products_for' do
    it "should return the suggested products in the order: shoe, bag and accessory" do
      FactoryGirl.create(:basic_bag_simple, :product => product_c, :inventory => 1)
      FactoryGirl.create(:basic_accessory_simple, :product => product_g, :inventory => 1)
      subject.suggested_products_for(sporty_profile, "37").should == [product_f, product_c, product_g]
    end
  end

  describe '#remove_color_variations' do
    let(:shoe_a_black)  { double :shoe, :name => 'Shoe A', :'sold_out?' => false }
    let(:shoe_a_red)    { double :shoe, :name => 'Shoe A', :'sold_out?' => false }
    let(:shoe_b_green)  { double :shoe, :name => 'Shoe B', :'sold_out?' => false }
    let(:products)      { [shoe_a_black, shoe_b_green, shoe_a_red] }

    context 'when no product is sold out' do
      it 'should return only one color for products with the same name' do
        subject.remove_color_variations(products).should == [shoe_a_black, shoe_b_green]
      end
    end

    context 'when the first product in a color set is sold out' do
      before :each do
        shoe_a_black.stub(:'sold_out?').and_return(true)
      end
      it 'should return the second color in the place of the sold out one' do
        subject.remove_color_variations(products).should == [shoe_a_red, shoe_b_green]
      end
    end

    context 'when the second product in a color set is sold out' do
      before :each do
        shoe_a_red.stub(:'sold_out?').and_return(true)
      end
      it 'should return the first color and hide the one sold out' do
        subject.remove_color_variations(products).should == [shoe_a_black, shoe_b_green]
      end
    end
  end
end
