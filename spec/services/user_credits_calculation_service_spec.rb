require "spec_helper"

describe UserCreditsCalculationService do

  describe "#initialize" do
    it "have to raise error without user" do
      expect(described_class).to raise_error
    end
  end

  context "having user" do
    let(:user) { FactoryGirl.create(:member) }
    let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
    let(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => loyalty_program_credit_type) }
    let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
    let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }
    let(:order) {FactoryGirl.create(:order, :user => user)}
    let(:amount) { BigDecimal.new("33.33") }
    let(:credits_attrs) {{:amount => amount, :order => order}}
    let(:user_without_credits){ FactoryGirl.create(:member) }
    context "without credits" do
      it "returns '0' on total" do
        user_credit = UserCreditsCalculationService.new(user_without_credits)
        expect(user_credit.user_credits_sum.to_s).to eql("0.0")
      end
      it "returns '0' on loyalty program" do
        user_credit = UserCreditsCalculationService.new(user_without_credits)
        expect(user_credit.user_credits_sum(type: "loyalty_program").to_s).to eql("0.0")
      end
    end
    context "with credits" do
      before do
        user.user_credits_for(:invite).add(:amount => 10.0)
        user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
      end

      it "returns total of credits value" do
        user_credit = UserCreditsCalculationService.new(user)
        expect(user_credit.user_credits_sum.to_s).to eql("43.33")
      end
      it "returns total on invite" do
        user_credit = UserCreditsCalculationService.new(user)
        expect(user_credit.user_credits_sum(types: ["invite"]).to_s).to eql("10.0")
      end
      it "returns total on invite and loyalty" do
        user_credit = UserCreditsCalculationService.new(user)
        expect(user_credit.user_credits_sum(types: ["invite", "loyalty_program"]).to_s).to eql("43.33")
      end
    end
  end
end
