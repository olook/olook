# -*- encoding : utf-8 -*-
require "spec_helper"

describe Admin::ShippingCompaniesController do
  describe "should include a named route to" do
    it "the shipping_company index" do
      {get: admin_shipping_companies_path}.should route_to("admin/shipping_companies#index")
    end
    it "show an existing shipping_company" do
      {get: admin_shipping_company_path(1)}.should route_to("admin/shipping_companies#show", id: '1')
    end
    it "create a new shipping_company" do
      {get: new_admin_shipping_company_path}.should route_to("admin/shipping_companies#new")
    end
    it "edit an existing shipping_company" do
      {get: edit_admin_shipping_company_path(1)}.should route_to("admin/shipping_companies#edit", id: '1')
    end
  end

  describe "should include unnamed route to" do
    it "#create" do
      {post: "/admin/shipping_companies"}.should route_to("admin/shipping_companies#create")
    end

    it "#update" do
      {put: "/admin/shipping_companies/1"}.should route_to("admin/shipping_companies#update", id: "1")
    end

    it "#destroy" do
      {delete: "/admin/shipping_companies/1"}.should route_to("admin/shipping_companies#destroy", id: "1")
    end
  end
end
