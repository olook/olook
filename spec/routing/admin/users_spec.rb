# -*- encoding : utf-8 -*-
require "spec_helper"

describe Admin::UsersController do
  describe "should include a named route to" do
    it "the user index" do
      {get: admin_users_path}.should route_to("admin/users#index")
    end
    it "show an existing user" do
      {get: admin_user_path(1)}.should route_to("admin/users#show", id: '1')
    end
    it "edit an existing user" do
      {get: edit_admin_user_path(1)}.should route_to("admin/users#edit", id: '1')
    end
    it "generate statistics about the user base" do
      {get: statistics_admin_users_path}.should route_to("admin/users#statistics")
    end
  end

  describe "should include unnamed route to" do
    it "#update" do
      {put: "/admin/users/1"}.should route_to("admin/users#update", id: "1")
    end
  end
end
