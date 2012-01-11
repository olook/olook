require "spec_helper"

describe Admin::LandingPagesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/landing_pages").should route_to("admin/landing_pages#index")
    end

    it "routes to #new" do
      get("/admin/landing_pages/new").should route_to("admin/landing_pages#new")
    end

    it "routes to #show" do
      get("/admin/landing_pages/1").should route_to("admin/landing_pages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/landing_pages/1/edit").should route_to("admin/landing_pages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/landing_pages").should route_to("admin/landing_pages#create")
    end

    it "routes to #update" do
      put("/admin/landing_pages/1").should route_to("admin/landing_pages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/landing_pages/1").should route_to("admin/landing_pages#destroy", :id => "1")
    end

  end
end
