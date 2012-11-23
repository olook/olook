require 'spec_helper'

describe GiftBox do
  describe "#validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :active }
  end
end
