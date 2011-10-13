# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MemberHelper do
  it '#link_to_invitation should generate a message and a link' do
    member = double("member")
    fake_invite_token = 'XyXyXy'
    member.stub(:invite_token) { fake_invite_token }
    helper.link_to_invitation(member).should include(fake_invite_token)
  end

  it '#invitation_link should generate a link with the invite_token of the inviting member' do
    member = double("member")
    fake_invite_token = 'XyXyXy'
    member.stub(:invite_token) { fake_invite_token }
    helper.invitation_link(member).should include(fake_invite_token)
  end

  it '#invite_message should return a text string' do
    helper.invite_message.should be_true
  end

end
