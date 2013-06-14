require "spec_helper"

describe Admin::HighlightsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/highlights").should route_to("admin/highlights#index")
    end

    it "routes to #new" do
      get("/admin/highlights/new").should route_to("admin/highlights#new")
    end

    it "routes to #show" do
      get("/admin/highlights/1").should route_to("admin/highlights#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/highlights/1/edit").should route_to("admin/highlights#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/highlights").should route_to("admin/highlights#create")
    end

    it "routes to #update" do
      put("/admin/highlights/1").should route_to("admin/highlights#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/highlights/1").should route_to("admin/highlights#destroy", :id => "1")
    end

  end
end
