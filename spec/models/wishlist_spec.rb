require 'spec_helper'

describe Wishlist do
  subject(:wishlist) { Wishlist.new }  
  
  describe "validations" do
    it { should belong_to :user }
    it { should have_many :wished_products }
  end

  describe "a just created wishlist" do
    it { expect(wishlist).to have(0).wished_products }
  end

  describe "#has?" do
    context 'empty wishlist' do
      subject{Wishlist.new.has?(123)}
      it {should be_false}
    end

    context 'wishlist has the product 123' do
      let(:wished_product_mock) {OpenStruct.new({product_id: 123})}

      before(:each) do
        wishlist.stub(:wished_products).and_return([wished_product_mock])
      end

      it {should have(1).wished_products}

      describe "for product_id 123" do
        it 'returns true' do
          expect(wishlist.has?(123)).to be_true
        end
      end
      
      describe 'for product_id 999' do
        it 'returns false' do
          expect(wishlist.has?(999)).to be_false
        end
      end
    end
    
  end

  describe "#add" do
    context "empty wishlist" do
      describe "when adding a valid variant" do
        let(:variant) {FactoryGirl.create(:shoe_variant)}

        it "returns true" do
          expect(wishlist.add(variant)).to be_true
        end

        it "increase the number of wished products" do
          wishlist.add(variant)
          expect(wishlist).to have(1).wished_products
        end
      end

      describe "when adding an invalid variant" do
        let(:invalid_variant) {Variant.new}
        it "returns false" do
          expect(wishlist.add(invalid_variant)).to be_false
        end
      end

      describe "when adding a nil variant" do
        it {expect { wishlist.add(nil) }.to raise_error("variant cannot be nil")}
      end
    end

    context "wishlist with one variant of product 123" do
      let(:wished_product) {OpenStruct.new({product_id: '123', variant_number: '123-P'})}
      let(:already_added_variant) {OpenStruct.new({number: '123-P', product_id: '123', valid?: true})}
      let(:new_variant) {OpenStruct.new({number: '123-G', product_id: '123', valid?: true})}

      before(:each) do
        wishlist.stub(:wished_products).and_return([wished_product])
      end

      describe "when adding another variant of the same product" do
        it "should increase wished_products list" do
          wishlist.add new_variant
          expect(wishlist).to have(2).wished_products
        end

        it "return true" do
          expect(wishlist.add(new_variant)).to be_true
        end
      end

      describe "when adding an already added variant" do
        it "should not increase wished_products list" do
          wishlist.add already_added_variant
          expect(wishlist).to have(1).wished_products
        end

        it "return false" do
          expect(wishlist.add(already_added_variant)).to be_false
        end
      end
    end

  end

  describe "#remove" do
    it {should respond_to(:remove).with(1).arguments}
    
    context 'empty wishlist' do
      it "returns false" do
        expect(wishlist.remove(1002)).to be_false
      end
    end

    context 'wishlist with elements' do
      let(:variant) {FactoryGirl.create(:shoe_variant)}
      before(:each) do
        wishlist.add(variant)       
      end
      
      describe "when removing an existing wished product" do
        it "returns true" do
          expect(wishlist.remove(variant.number)).to be_true
        end
      end   

      describe "when removing a non existing wished product" do
        it "returns false" do
          non_existing_wished_product = 89098
          expect(wishlist.remove(non_existing_wished_product)).to be_false
        end
      end
    end
  end

  describe ".for" do
    let(:user) { FactoryGirl.create(:user)}
    context "user does not have a wishlist" do
      subject(:new_wishlist) { Wishlist.for(user) }

      it "create and return a new wishlist" do
        expect(new_wishlist).to have(0).wished_products
      end

      it "associates the new wishlist with de user" do
        expect(new_wishlist.user).to eql(user)
      end
    end

    context "user already has a wishlist" do
      let(:shoe) {FactoryGirl.create(:shoe_variant)}
      before(:each) do
        wishlist = Wishlist.create({user_id: user.id})
        wishlist.add shoe
      end

      it "finds the users wishlist" do
        expect(Wishlist.for(user)).to have(1).wished_products
      end
    end
    
  end
end