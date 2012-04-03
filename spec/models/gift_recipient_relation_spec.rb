require 'spec_helper'

describe GiftRecipientRelation do
  describe "validation" do
    it { should validate_presence_of(:name) }
  end
end
