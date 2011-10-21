# -*- encoding : utf-8 -*-
require "spec_helper"

describe "The member controller" do
  it "should include a named route to the member's invite page" do
    {get: member_invite_path}.should route_to("members#invite")
  end
  it "should include a named route to accept invitations" do
    {get: accept_invitation_path}.should route_to("members#accept_invitation")
  end
  it "should include a named route to send invites by e-mail" do
    {post: member_invite_by_email_path}.should route_to("members#invite_by_email")
  end
end
