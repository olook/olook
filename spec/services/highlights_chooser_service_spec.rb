require 'spec_helper'

describe HighlightsChooserService do
  context "when all highlights are filled, between range and active" do
    it "choose the highlight " do
      hl = {center: FactoryGirl.create(:highlight, :position_1),left: FactoryGirl.create(:highlight, :position_2),right: FactoryGirl.create(:highlight, :position_3)}
      expect(described_class.new.choose).to eq(hl)
    end
  end
  
  context "when left highlight is out of range " do
    it "choose the default highlight " do
      hl = {center: FactoryGirl.create(:highlight, :position_1),left: FactoryGirl.create(:highlight, :default)  , right: FactoryGirl.create(:highlight, :position_3)}
      expect(described_class.new.choose).to eq(hl)
    end
  end

end