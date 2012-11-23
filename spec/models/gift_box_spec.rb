require 'spec_helper'

describe GiftBox do
  describe "#validations" do
    it { should validate_presence_of :name }
  end
end
