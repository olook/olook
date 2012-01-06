# -*- encoding : utf-8 -*-

require "spec_helper"

describe LandingPage do
  subject do
    LandingPage.new(:image => "abc.jpg",
                    :link_title => "My Landing Page",
                    :link_url => "http://www.olook.com.br/vendas",
                    :title_url => "landing-page")
  end

  context "attributes validation" do
    it { should validate_presence_of(:image) }
    it { should validate_presence_of(:link_title) }
    it { should validate_presence_of(:title_url) }

    context "#link_url" do
      it { should validate_presence_of(:link_url) }
      it { should_not allow_value("spaced url").for(:link_url) }
      it { should_not allow_value("tabbed\turl").for(:link_url) }
      it { should_not allow_value("accénted-url").for(:link_url) }
      it { should allow_value("url-de-teste").for(:link_url) }
      it { should allow_value("url_with_underscores").for(:link_url) }
    end

  end

end