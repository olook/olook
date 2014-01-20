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

  describe "#add_wished_variant" do

    describe "when adding an existing variant" do
      let(:variant) {FactoryGirl.create(:shoe_variant)}

      it "returns true" do
        expect(wishlist.add_variant(variant)).to be_true
      end

      it "increase the number of wished products" do
        wishlist.add_variant(variant)
        expect(wishlist).to have(1).wished_products
      end
    end

    describe "when adding an invalid variant" do
      let(:invalid_variant) {Variant.new}
      it "returns false" do
        expect(wishlist.add_variant(invalid_variant)).to be_false
      end
    end

    describe "when adding a nil variant" do
      it {expect { wishlist.add_variant(nil) }.to raise_error("variant cannot be nil")}
    end

  end

  describe "#remove" do
    it {should respond_to :remove}
    
    context 'empty wishlist' do
      it "returns false" do
        expect(wishlist.remove(1002)).to be_false
      end
    end

    context 'wishlist with elements' do
      let(:variant) {FactoryGirl.create(:shoe_variant)}
      before(:each) do
        wishlist.add_variant(variant)       
      end
      
      describe "when removing an existing wished product" do
        it "return true" do
          expect(wishlist.remove(variant.number)).to be_true
        end
      end   

      describe "when removing a non existing wished product" do
        it "return false" do
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
        wishlist.add_variant shoe
      end

      it "finds the users wishlist" do
        expect(Wishlist.for(user)).to have(1).wished_products
      end


    end
    
  end

end
