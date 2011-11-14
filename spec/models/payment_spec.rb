require "spec_helper"

describe Payment do
  context "attributes validation" do
    it { should validate_presence_of(:user_name) }
    it { should validate_presence_of(:payment_type) }
    it { should validate_presence_of(:credit_card_number) }
    it { should belong_to(:order) }
  end
end
