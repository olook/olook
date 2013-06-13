require 'spec_helper'

describe Highlight do

  describe "validations" do
    it { should validate_presence_of :image }
    it { should validate_presence_of :link }
    it { should validate_presence_of :position }
  end

  describe ".highlights_to_show" do
    
    it "should sort the Highlights by position" do
      Highlight.should_receive(:all).with(order: :position)
      sorted_by_position = Highlight.highlights_to_show
    end

  end

end
