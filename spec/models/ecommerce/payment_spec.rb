require "spec_helper"

describe Payment do
  it { should belong_to(:order) }

  context "creating a Payment" do
    it "should generate a identification code" do
      payment = FactoryGirl.create(:payment)
      payment.identification_code.should_not be_nil
    end
  end
end
