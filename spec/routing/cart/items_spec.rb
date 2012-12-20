# -*- encoding : utf-8 -*-
require "spec_helper"

describe Cart::ItemsController do
  describe "routing" do
    it "routes to #create" do
      post("/sacola/items").should route_to("cart/items#create")
    end

    it "routes to #destroy" do
      delete("/sacola/items/1").should route_to("cart/items#destroy", :id => "1")
    end
  end
end
