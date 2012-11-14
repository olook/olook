require 'spec_helper'

describe Campaign do

=begin
  context "attributes validation" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :start_at }
    it { should validate_presence_of :end_at }
  end
=end

  context "on create" do
    let!(:valid_campaign) { FactoryGirl.create(:campaign) }
    let(:invalid_campaign) { FactoryGirl.build(:second_campaign) }

    it "should not create a campaign because the date is in range of a valid campaign already created" do
      invalid_campaign.start_at = "2012-11-13"
      invalid_campaign.end_at = "2012-11-13"
      invalid_campaign.should be_invalid
    end

    it "should not create a campaign because the date is in range of a valid campaign already created" do
      invalid_campaign.start_at = "2012-11-08"
      invalid_campaign.end_at = "2012-11-12"
      invalid_campaign.should be_invalid
    end

    it "should not create a campaign because the date is in range of a valid campaign already created" do
      invalid_campaign.start_at = "2012-11-12"
      invalid_campaign.end_at = "2012-11-17"
      invalid_campaign.should be_invalid
    end

    it "should create a campaign" do
      invalid_campaign.start_at = "2012-12-10"
      invalid_campaign.end_at = "2012-12-10"
      invalid_campaign.should be_valid
    end
  end

  context "on .any_campaign_active_today?" do
    let!(:valid_campaign) { FactoryGirl.create(:campaign) }
    let(:new_campaign) { FactoryGirl.build(:second_campaign) }
    it "should return true for active campaign because already exists a campaign" do
      new_campaign.start_at = "2012-12-10"
      new_campaign.end_at = "2012-12-10"
      Campaign.any_campaign_active_today?(new_campaign).should eq(true)
    end

    it "should return false for active campaign because the search exclude the current campaign" do
      Campaign.any_campaign_active_today?(valid_campaign).should eq(false)
    end
  end

  context "on .invalid_range?" do
    let!(:valid_campaign) { FactoryGirl.create(:campaign) }
    let(:new_campaign) { FactoryGirl.build(:second_campaign) }

    it "should return true because range of new campaign is not available" do
      new_campaign.start_at = "2012-11-10"
      new_campaign.end_at = "2012-11-14"
      Campaign.invalid_range?(new_campaign).should eq(true)
    end

    it "should return false because range of new campaign is available" do
      new_campaign.start_at = "2012-12-10"
      new_campaign.end_at = "2012-12-14"
      Campaign.invalid_range?(new_campaign).should eq(false)
    end
  end

end
