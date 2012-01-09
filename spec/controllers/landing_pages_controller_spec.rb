require 'spec_helper'

describe LandingPagesController do
  describe "GET show" do

    let!(:landing) { LandingPage.create!(:page_url => "teste", :page_title => "Testando") }

    it "gets page by url" do
      LandingPage.should_receive(:find_by_page_url).with(landing.page_url)
      get :show, :page_url => landing.page_url
    end

    it "assign the landing page found by url to @landing_page" do
      get :show, :page_url => landing.page_url
      assigns(:landing_page).should == landing
    end
  end
end