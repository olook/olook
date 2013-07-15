# encoding: utf-8
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

  describe "#associate" do
    before do
      @product = mock_model(Product)
      @collection_theme = mock_model(CollectionTheme)
    end
    subject { AssociateProductWithCollectionThemeService.new("1", "123") }
    it "should call product_ids on collection" do
      pending "Fazer uma discussão de funcionalidade com o Tiago"
      CollectionTheme.should_receive(:find_by_id).with("1").and_return(@collection_theme)
      Product.should_receive(:find_by_id).with("123").and_return(@product)
    end
  end

  describe "#process!" do
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
