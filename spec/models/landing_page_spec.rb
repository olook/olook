# -*- encoding : utf-8 -*-

require "spec_helper"

describe LandingPage do
  subject do
    LandingPage.new(:page_image => "abc.jpg",
                    :page_title => "My Landing Page",
                    :page_url => "landing-page")
  end

  context "attributes validation" do
    it { should validate_presence_of(:page_image) }
    it { should validate_presence_of(:page_title) }
    it { should validate_presence_of(:page_url) }

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