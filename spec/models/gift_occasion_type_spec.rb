require 'spec_helper'

describe GiftOccasionType do
  context "validation" do
    it { should validate_presence_of :name }
  end

  
end
