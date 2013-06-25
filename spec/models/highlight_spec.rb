require 'spec_helper'
# require '../factories/highlights'

describe Highlight do

  describe "validations" do
    it { should validate_presence_of :image }
    it { should validate_presence_of :link }
    it { should validate_presence_of :position }
  end

  describe ".highlights_to_show" do
    
    it "should sort the Highlights by position" do
      first = FactoryGirl.create(:highlight, :at_position_1)
      second = FactoryGirl.create(:highlight, :at_position_2)
      third = FactoryGirl.create(:highlight, :at_position_3)

      sorted_by_position = Highlight.highlights_to_show HighlightType::CAROUSEL
      expect(sorted_by_position[0]).to eql first
      expect(sorted_by_position[1]).to eql second
      expect(sorted_by_position[2]).to eql third
    end

  end

end
