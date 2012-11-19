require 'spec_helper'

describe Campaign do

  describe "#validations" do
    context "should validates" do
      it { should validate_presence_of :title }
      it { should validate_presence_of :start_at }
      it { should validate_presence_of :end_at }
    end
  end

  describe "on #create" do
    let(:valid_campaign) { FactoryGirl.create(:campaign) }
    let(:invalid_campaign) { FactoryGirl.build(:second_campaign) }

    # before do
    #   valid_campaign.start_at = "2012-11-10" #1.months.ago
    #   valid_campaign.end_at = "2012-11-15" #10.days.since
    #   valid_campaign.save
    # end

    context "should not create a campaign" do
      it "the date is in range of a valid campaign already created" do
        invalid_campaign.start_at = "2012-11-13"
        invalid_campaign.end_at = "2012-11-13"
        invalid_campaign.should be_invalid
      end

      it "the date is in range of a valid campaign already created" do
        invalid_campaign.start_at = "2012-11-08"
        invalid_campaign.end_at = "2012-11-12"
        invalid_campaign.should be_invalid
      end

      it "the date is in range of a valid campaign already created" do
        invalid_campaign.start_at = "2012-11-12"
        invalid_campaign.end_at = "2012-11-17"
        invalid_campaign.should be_invalid
      end
    end
    context "should create a campaign" do
      it "valid campaign" do
        invalid_campaign.start_at = "2012-12-10"
        invalid_campaign.end_at = "2012-12-10"
        invalid_campaign.should be_valid
      end
    end
  end

  describe ".any_campaign_active_today?" do
    let(:valid_campaign) { FactoryGirl.create(:campaign) }
    let(:new_campaign) { FactoryGirl.build(:second_campaign) }
    context "should return true" do
    
      before do
        valid_campaign.start_at = 1.months.ago
        valid_campaign.end_at = 10.days.since
        valid_campaign.save
      end

      it "for active campaign because already exists a campaign" do
        new_campaign.start_at = Date.today
        new_campaign.end_at = 1.days.since

        Campaign.any_campaign_active_today?(new_campaign).should eq(true)
      end
    end

    context "should return false" do
      it "for active campaign because the search excludes the current campaign" do
        Campaign.any_campaign_active_today?(valid_campaign).should eq(false)
      end
    end
  end

  describe ".invalid_range?" do
    let!(:valid_campaign) { FactoryGirl.create(:campaign) }
    let(:new_campaign) { FactoryGirl.build(:second_campaign) }

    context "should return true" do
      it "because range of new campaign is not available" do
        new_campaign.start_at = "2012-11-10"
        new_campaign.end_at = "2012-11-14"
        Campaign.invalid_range?(new_campaign).should eq(true)
      end
    end

    context "should return false" do
      it "because range of new campaign is available" do
        new_campaign.start_at = "2012-12-10"
        new_campaign.end_at = "2012-12-14"
        Campaign.invalid_range?(new_campaign).should eq(false)
      end
    end
  end

  describe "on .activated_campaign" do
    context "should return the activated campaign" do
      let(:valid_campaign) { FactoryGirl.create(:campaign) }
      it "A campaign active today" do
        valid_campaign.start_at = Date.today
        valid_campaign.end_at = 2.days.since
        valid_campaign.save!

        Campaign.activated_campaign.should eq(valid_campaign)
      end
    end

    context "should return nil" do
      it "No campaign active today" do
        Campaign.activated_campaign.should eq(nil)
      end
    end

  end

end
