require "spec_helper"

describe Tracking do
  describe "relationshios" do
    it { should belong_to :user }
  end

  context "scopes" do
    let!(:google_tracking) { FactoryGirl.create(:google_tracking) }
    let!(:tracking) { FactoryGirl.create(:tracking) }

    describe "#google" do
      it "includes a tracking with gclid and placement" do
        Tracking.google.should include(google_tracking)
      end
    end

    describe "#google_campaigns" do
      let!(:google_tracking_b) { FactoryGirl.create(:google_tracking) }
      it "groups google trackings by placement" do
        Tracking.google_campaigns.all.size.should == 1
      end
    end

    describe "#campaigns" do
      let!(:tracking_two) { FactoryGirl.create(:tracking) }

      it "includes a tracking with utm_content" do
        Tracking.campaigns.should include(tracking)
      end

      it "groups two similar trackings in one record" do
        Tracking.campaigns.all.size.should == 1
      end
    end
  end

  describe "#total_revenue" do
    let!(:user_a) { FactoryGirl.create(:member) }
    let!(:user_b) { FactoryGirl.create(:member) }
    let!(:order_a) { FactoryGirl.create(:clean_order, :user => user_a) }
    let!(:order_b) { FactoryGirl.create(:clean_order, :user => user_b) }
    let!(:tracking_a) { FactoryGirl.create(:tracking, :user => user_a) }
    let!(:tracking_b) { FactoryGirl.create(:tracking, :user => user_b) }

    before do
      order_a.payment.billet_printed
      order_a.payment.authorized
      order_b.payment.billet_printed
      order_b.payment.authorized
    end

    it "returns the total revenue of all users with to the same tracking type" do
      User.any_instance.stub(:total_revenue).with(:total).and_return(BigDecimal.new("100"))
      tracking_a.total_revenue.should == 200
    end
  end

  describe "#total_revenue_for_google" do
    let!(:user_a) { FactoryGirl.create(:member) }
    let!(:user_b) { FactoryGirl.create(:member) }
    let!(:order_a) { FactoryGirl.create(:clean_order, :user => user_a) }
    let!(:order_b) { FactoryGirl.create(:clean_order, :user => user_b) }
    let!(:tracking_a) { FactoryGirl.create(:google_tracking, :user => user_a) }
    let!(:tracking_b) { FactoryGirl.create(:google_tracking, :user => user_b) }

    before do
      order_a.payment.billet_printed
      order_a.payment.authorized
      order_b.payment.billet_printed
      order_b.payment.authorized
    end

    it "gets the total revenue of all users with the same placement" do
      User.any_instance.stub(:total_revenue).with(:total).and_return(BigDecimal.new("100"))
      tracking_a.total_revenue.should == 200
    end
  end

  describe "#related_with_complete_payment_for_google" do
    let!(:user_a) { FactoryGirl.create(:member) }
    let!(:user_b) { FactoryGirl.create(:member) }
    let!(:order_a) { FactoryGirl.create(:clean_order, :user => user_a) }
    let!(:order_b) { FactoryGirl.create(:clean_order, :user => user_b) }
    let!(:tracking_a) { FactoryGirl.create(:google_tracking, :user => user_a) }
    let!(:tracking_b) { FactoryGirl.create(:google_tracking, :user => user_b) }

    before do
      order_a.payment.billet_printed
      order_a.payment.authorized
      order_b.payment.billet_printed
      order_b.payment.authorized
    end

    it "returns all trackings with complete payment from users with the same placement" do
      tracking_a.related_with_complete_payment_for_google.should == [tracking_a, tracking_b]
    end
  end

  describe "@related_with_complete_payment" do
    let!(:user_a) { FactoryGirl.create(:member) }
    let!(:user_b) { FactoryGirl.create(:member) }
    let!(:order_a) { FactoryGirl.create(:clean_order, :user => user_a) }
    let!(:order_b) { FactoryGirl.create(:clean_order, :user => user_b) }
    let!(:tracking_a) { FactoryGirl.create(:tracking, :user => user_a) }
    let!(:tracking_b) { FactoryGirl.create(:tracking, :user => user_b) }

    before do
      order_a.payment.billet_printed
      order_a.payment.authorized
      order_b.payment.billet_printed
      order_b.payment.authorized
    end

    it "returns all trackings with complete payment from users with " do
      tracking_a.related_with_complete_payment.should == [tracking_a, tracking_b]
    end
  end
end