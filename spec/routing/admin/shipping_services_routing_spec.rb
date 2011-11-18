# -*- encoding : utf-8 -*-
require "spec_helper"

describe Admin::ShippingServicesController do
  describe "should include a named route to" do
    it "the shipping_service index" do
      {get: admin_shipping_services_path}.should route_to("admin/shipping_services#index")
    end
    it "show an existing shipping_service" do
      {get: admin_shipping_service_path(1)}.should route_to("admin/shipping_services#show", id: '1')
    end
    it "create a new shipping_service" do
      {get: new_admin_shipping_service_path}.should route_to("admin/shipping_services#new")
    end
    it "edit an existing shipping_service" do
      {get: edit_admin_shipping_service_path(1)}.should route_to("admin/shipping_services#edit", id: '1')
    end
  end

  describe "should include unnamed route to" do
    it "#create" do
      {post: "/admin/shipping_services"}.should route_to("admin/shipping_services#create")
    end

    it "#update" do
      {put: "/admin/shipping_services/1"}.should route_to("admin/shipping_services#update", id: "1")
    end

    it "#destroy" do
      {delete: "/admin/shipping_services/1"}.should route_to("admin/shipping_services#destroy", id: "1")
    end
  end
end
