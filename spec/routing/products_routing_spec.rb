# -*- encoding : utf-8 -*-
require "spec_helper"

describe Admin::ProductsController do
  describe "should include a named route to" do
    it "the product index" do
      {get: admin_products_path}.should route_to("admin/products#index")
    end
    it "show an existing product" do
      {get: admin_product_path(1)}.should route_to("admin/products#show", id: '1')
    end
    it "create a new product" do
      {get: new_admin_product_path}.should route_to("admin/products#new")
    end
    it "edit an existing product" do
      {get: edit_admin_product_path(1)}.should route_to("admin/products#edit", id: '1')
    end
    it "add a related product" do
      {post: add_related_admin_product_path(1)}.
        should route_to("admin/products#add_related", id: '1')
    end
    it "remove a related product" do
      {delete: remove_related_admin_product_path(1, 22)}.
        should route_to("admin/products#remove_related", id: '1', related_product_id: '22')
    end
  end

  describe "should include unnamed route to" do
    it "#create" do
      {post: "/admin/products"}.should route_to("admin/products#create")
    end

    it "#update" do
      {put: "/admin/products/1"}.should route_to("admin/products#update", id: "1")
    end

    it "#destroy" do
      {delete: "/admin/products/1"}.should route_to("admin/products#destroy", id: "1")
    end
  end
end
