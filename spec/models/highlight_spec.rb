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

      sorted_by_position = Highlight.highlights_to_show
      expect(sorted_by_position).to eql [first, second, third]
    end

  end

end
