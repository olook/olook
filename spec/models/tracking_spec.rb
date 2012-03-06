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
end