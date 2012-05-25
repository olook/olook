require 'spec_helper'

describe GiftRecipientRelation do
  context "validation" do
    it { should validate_presence_of :name }
  end

  
end
