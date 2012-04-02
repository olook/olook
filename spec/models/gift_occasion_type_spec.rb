require 'spec_helper'

describe OccasionType do
  describe "validation" do
    it { should validate_presence_of(:name) }
  end
end
