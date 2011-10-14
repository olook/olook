require "spec_helper"

describe Admin::ProductsController do
  describe "routing" do

    it "routes to #index" do
      get("/products").should route_to("admin/products#index")
    end

    it "routes to #new" do
      get("/products/new").should route_to("admin/products#new")
    end

    it "routes to #show" do
      get("/products/1").should route_to("admin/products#show", :id => "1")
    end

    it "routes to #edit" do
      get("/products/1/edit").should route_to("admin/products#edit", :id => "1")
    end

    it "routes to #create" do
      post("/products").should route_to("admin/products#create")
    end

    it "routes to #update" do
      put("/products/1").should route_to("admin/products#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/products/1").should route_to("admin/products#destroy", :id => "1")
    end

  end
end
