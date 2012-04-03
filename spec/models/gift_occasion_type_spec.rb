require 'spec_helper'

describe GiftOccasionType do
  describe "validation" do
    it { should validate_presence_of(:name) }
  end
end
