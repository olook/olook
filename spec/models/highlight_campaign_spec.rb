require 'spec_helper'

describe HighlightCampaign do
  describe "Validations" do
    it { should validate_presence_of(:label) }
    it { should respond_to :has_products? }
    it { should respond_to :cache_key }
    it { should respond_to :products }
  end

  describe ".find_campaign" do
    it "never return nil" do
      expect(HighlightCampaign.find_campaign(nil)).not_to be_nil
    end

    context "when can't find the campaign" do
      # before do
        subject{HighlightCampaign.find_campaign("not existing campaign")}
      # end
      it "return a dummy object" do
        expect(subject).to be_a(OpenStruct)
      end

      it "the dummy object respond to has_products?" do
        expect(subject.has_products?).to be_false
      end

      it "the dummy object respond to products" do
        expect(subject.products).to eq []
      end

      it "the dummy object respond to product_ids" do
        expect(subject.product_ids).to eq ""
      end

      it "the dummy object respond to cache_key" do
        expect(subject.cache_key).to be_nil
      end



    end
  end
end
