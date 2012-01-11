require 'spec_helper'

describe LandingPagesController do
  describe "GET show" do

    let!(:landing) { LandingPage.create!(:page_url => "teste", :page_title => "Testando", :enabled => true, :button_url => "http://www.olook.com") }

    it "gets page by url" do
      LandingPage.should_receive(:find_by_page_url!).with(landing.page_url).and_return(landing)
      get :show, :page_url => landing.page_url
    end

    it "assigns the landing page found by url to @landing_page" do
      get :show, :page_url => landing.page_url
      assigns(:landing_page).should == landing
    end

    context "when landing page is disabled" do
      before do
        landing.enabled = false
        landing.save!
      end

      it "redirects user to home path" do
        get :show, :page_url => landing.page_url
        response.should redirect_to(root_path)
      end
    end

    context "when landing page does not exist" do
      it "raises an ActiveRecord::NotFound error" do
        expect do
          get :show, :page_url => "404-url"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end