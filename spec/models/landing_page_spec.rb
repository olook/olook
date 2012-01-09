# -*- encoding : utf-8 -*-

require "spec_helper"

describe LandingPage do
  let!(:landing) { FactoryGirl.create(:landing_page) }
  subject { FactoryGirl.build(:landing_page) }

  context "attributes validation" do
    it { should validate_presence_of(:page_title) }
    it { should validate_presence_of(:page_url) }
    it { should validate_uniqueness_of(:page_title) }
    it { should validate_uniqueness_of(:page_url) }

    context "#link_url" do
      it { should validate_presence_of(:page_url) }
      it { should_not allow_value("spaced url").for(:page_url) }
      it { should_not allow_value("tabbed\turl").for(:page_url) }
      it { should_not allow_value("accénted-url").for(:page_url) }
      it { should allow_value("url-de-teste").for(:page_url) }
      it { should allow_value("url_with_underscores").for(:page_url) }
    end

  end

end