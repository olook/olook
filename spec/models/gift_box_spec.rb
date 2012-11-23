require 'spec_helper'

describe GiftBox do
  describe "#validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :active }
    it { should validate_presence_of :thumb_image }
  end
end
