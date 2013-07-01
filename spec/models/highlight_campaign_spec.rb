require 'spec_helper'

describe HighlightCampaign do
  describe "Validations" do
    it { should validate_presence_of(:label) }
  end
  describe "Acossiations" do
    it { should have_and_belong_to_many(:products) }
  end
  describe "#add_products" do
    context "When receive empty || nil string"
    it "return 2" do
      expect(subject.add_products("")).to include(code: "2",fail_product_ids: [])
    end
  end
end
