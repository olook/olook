require 'spec_helper'

describe Campaign do

  describe "#validations" do
    context "should validates" do
      it { should validate_presence_of :title }
      it { should validate_presence_of :start_at }
      it { should validate_presence_of :end_at }
      it { should have_many :campaign_pages }
      it { should have_many(:pages).through(:campaign_pages) }
    end
  end

  describe "#ovelaps?" do
    let(:campaign) {Campaign.new ({:start_at => "2012-01-01", :end_at => "2012-01-15"})}

    context "same date range" do
      it "should ovelap" do
        campaign.overlaps?(campaign).should be_true
      end
    end

    context "complete apart date ranges" do

      let(:non_overlapping_campaign) {Campaign.new ({:start_at => "2012-01-16", :end_at => "2012-02-15"})}

      it "should not ovelap" do
        campaign.overlaps?(non_overlapping_campaign).should be_false
      end
    end

    context "edge cases" do

      let(:ends_when_another_campaign_starts) {Campaign.new ({:start_at => "2011-12-15", :end_at => "2012-01-01"})}
      let(:starts_when_another_campaign_ends) {Campaign.new ({:start_at => "2012-01-15", :end_at => "2012-01-31"})}

      it "should overlap" do
        campaign.overlaps?(ends_when_another_campaign_starts).should be_true
      end

      it "should overlap" do
        campaign.overlaps?(starts_when_another_campaign_ends).should be_true
      end

    end

  end

  describe "on #create" do
    # valid_campaign must exist in the database before each spec
    let!(:valid_campaign) { FactoryGirl.create(:campaign) }
    let(:invalid_campaign) { FactoryGirl.build(:second_campaign) }

    # before do
    #   valid_campaign.start_at = "2012-11-10" #1.months.ago
    #   valid_campaign.end_at = "2012-11-15" #10.days.since
    #   valid_campaign.save
    # end

    context "should not create a campaign" do
      it "the date is in range of a valid campaign already created" do
        invalid_campaign.start_at = "2012-11-13"
        invalid_campaign.end_at = "2012-11-15"
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
        invalid_campaign.start_at = "2012-12-8"
        invalid_campaign.end_at = "2012-12-9"
        invalid_campaign.should be_valid
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

  describe "#show_banner_for?" do
    let(:campaign) {Campaign.new}
    let(:page) {Page.new({controller_name: "moments"})}

    context "when campaign has the page" do
      before do
        campaign.pages << page
      end

      it "show the banner" do
        params = params_for_controller("moments")       
        campaign.show_banner_for?(params).should be_true
      end

      it "show the banner ignoring the case" do
        params = params_for_controller("MoMents")       
        campaign.show_banner_for?(params).should be_true
      end
    end

    context "when the campaign has no pages" do
      it "don't show the banner" do
        params = params_for_controller("MoMents")
        campaign.show_banner_for?(params).should be_false
      end
    end

    context "when the campaign has a different page" do
      before do
        campaign.pages << page
      end

      it "don't show the banner" do
        params = params_for_controller("stylists")
        campaign.show_banner_for?(params).should be_false
      end
    end

  end

  private
    def params_for_controller controller_name
      {:controller => controller_name}
    end

end
