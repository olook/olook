require "spec_helper"

describe AssociateProductWithCollectionThemeService do
  subject {AssociateProductWithCollectionThemeService.new("","")}
  describe "#initialize" do
    it "returns hash" do
      expect(subject.response_keys).to be_kind_of(Hash)
    end
    it "have hash with not found key" do
      expect(subject.response_keys).to have_key(:not_found)
    end
    it "have hash with not inventory key" do
      expect(subject.response_keys).to have_key(:not_inventory)
    end
    it "have hash with not visible key" do
      expect(subject.response_keys).to have_key(:not_visible)
    end
    it "have hash with successfull key" do
      expect(subject.response_keys).to have_key(:success)
    end
  end

  #describe "#associate_collection_themes_and_products=" do
  #  let(:product1) {FactoryGirl.create(:shoe)}
  #  let(:product2) {FactoryGirl.create(:shoe)}
  #  let(:product3) {FactoryGirl.create(:shoe)}
  #  let!(:basic_shoe_size_35) { FactoryGirl.create :basic_shoe_size_35, :product => product1 }
  #  let!(:basic_shoe_size_40) { FactoryGirl.create :basic_shoe_size_40, :product => product2 }
  #  let!(:basic_shoe_size_37) { FactoryGirl.create :basic_shoe_size_37, :product => product3 }
  #  context "when dont have products" do
  #    it "associate ids" do
  #    end
  #  end
  #  context "when already have products" do
  #    it "make new associations" do
  #    end
  #
  #    it "remove old association" do
  #    end
  #  end
  #end
  describe "#process" do
    let!(:product) {FactoryGirl.create(:shoe)}
    subject {AssociateProductWithCollectionThemeService.new("",product.id.to_s)}
    context "When dont find products" do
      it "returns product id on not_found key" do
        Product.should_receive(:find_by_id).and_return(nil)
        subject.process!
        expect(subject.response_keys.fetch(:not_found)).to eql([product.id.to_s])
      end
    end
    context "When product dont have inventory" do
      it "returns product id on not_inventory key" do
        subject.process!
        expect(subject.response_keys.fetch(:not_inventory)).to eql([product.id])
      end
    end
    context "When product is not visible" do
      it "returns product id on not_visible key" do
        product.update_attributes(is_visible: false)
        subject.process!
        expect(subject.response_keys.fetch(:not_visible)).to eql([product.id])
      end
    end
    context "When product is avaliable" do
      it "returns product id on successful key" do
        Product.any_instance.should_receive(:inventory).and_return(2)
        subject.process!
        expect(subject.response_keys.fetch(:success)).to eql([product.id])
      end
    end
  end
end
