# -*- encoding : utf-8 -*-
require "spec_helper"

describe ProductController do
  describe "should include a named route to" do
    it "the product index" do
      {get: product_path(1)}.should route_to("product#index", :id => '1')
    end
  end
end
