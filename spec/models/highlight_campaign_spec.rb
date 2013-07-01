require 'spec_helper'

describe HighlightCampaign do
  describe "Validations" do
    it { should validate_presence_of(:label) }
  end
  describe "Acossiations" do
    it { should have_and_belong_to_many(:products) }
  end
  describe "#add_products" do
    context "When receive empty || nil string" do
      it "return 2" do
        expect(subject.add_products("")).to include(code: "2",fail_product_ids: [])
      end
    end
    context "When have products" do
      before do
        @product1 = FactoryGirl.create(:shoe)
        @product2 = FactoryGirl.create(:shoe)
      end
      context "and find all products" do
        it "return 0" do
          expect(subject.add_products("#{@product1.id},#{@product2.id}")).to include(code: "0",fail_product_ids: [])
        end
      end
      context "and dont find all products" do
        it "return 1" do
          expect(subject.add_products("#{@product1.id},#{@product2.id},123")).to include(code: "1",fail_product_ids: ["123"])
        end
      end
    end
  end
end
