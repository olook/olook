# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FacebookAdapter do
  subject { FacebookAdapter.new(:fake_access_token) }

  it "should get the friend list" do
    subject.adapter.should_receive(:get_connections).with("me", "friends")
    subject.friends
  end
end


