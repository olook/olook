require 'spec_helper'

describe HighlightsChooserService do
  context "when highlight is between range and is active on a given position" do
    it "choose the highlight " do
      hl = FactoryGirl.create(:highlight, :active)

      expect(described_class.new.choose(1)).to eq(hl)
    end
  end

  context "when highlight is beetween range and isn't active on a given position" do
    it "choose a default highlight" do
      hld = FactoryGirl.create(:highlight, :active_false_default_true)

      expect(described_class.new.choose(1)).to eq(hld)
    end
  end

  context "when highlight is out of range and isn't active on a given position" do
    it "choose a default highlight" do
      hlo = FactoryGirl.create(:highlight, :out_of_range_active_false)

      expect(described_class.new.choose(1)).to eq(hlo)
    end
  end

  context "when highlight is out of range and active on a given position" do
    it "choose a default highlight" do
      hlo = FactoryGirl.create(:highlight, :out_of_range_active_false)

      expect(described_class.new.choose(1)).to eq(hlo)
    end
  end

  context "when there's no highlight on range, active and default" do
    it "returns nothing" do
      hln = FactoryGirl.create(:highlight, :nothing)

      expect(described_class.new.choose(1)).to eq(nil)
    end
  end
end