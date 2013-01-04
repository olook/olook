require 'spec_helper'

describe CartItemAdjustment do
  describe "#validations" do
    context "should validates" do
      it { should validate_presence_of :value }
      it { should validate_presence_of :cart_item_id }
    end
  end
end
