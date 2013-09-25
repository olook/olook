# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CampaignEmailValidator do
  describe ".validate" do
    let!(:user) { FactoryGirl.create(:user) }
    let(:campaign_email) { CampaignEmail.new }
    subject { described_class.new({ }) }

    context "when there's any user with given email" do
      it "returns message Email já cadastrado" do
        campaign_email.email = user.email
        campaign_email.errors.should_receive(:add)
        expect(subject.validate(campaign_email)).to be_false
      end
    end

    context "when there's no user with given email" do
      it "doesn't return message Email já cadastrado" do
        campaign_email.email = "foo@bar.com"
        campaign_email.errors.should_not_receive(:add)
        subject.validate(campaign_email)
      end
    end
  end
end
