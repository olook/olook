# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FacebookAdapter do
  subject { FacebookAdapter.new(:fake_access_token) }

  it "should get the friend list" do
    friend_list = [{"name"=>"User name 1", "id"=>"1"}, {"name"=>"User name 2", "id"=>"2"}]
    subject.adapter.should_receive(:get_connections).at_least(2).times.with("me", "friends").and_return(friend_list)
    subject.facebook_friends.first.uid.should == "1"
    subject.facebook_friends.first.name.should == "User name 1"
  end

  it "should get the friends ids list" do
    friend_list = [{"name"=>"User name 1", "id"=>"1"}, {"name"=>"User name 2", "id"=>"2"}]
    subject.stub(:facebook_friends).and_return(friend_list)
    subject.facebook_friends_ids.should == ["1", "2"]
  end

  it "should get the facebook friends registered at olook" do
    subject.stub(:facebook_friends_ids).and_return(friends_ids = ["1", "2"])
    User.should_receive(:find_by_uid).with(friends_ids)
    subject.olook_facebook_friends
  end

  it "should post a message in the wall" do
    message, attachment, target, options = :message, {}, "me", {}
    subject.adapter.should_receive(:put_wall_post).with(message, attachment, target, options)
    subject.post_wall_message(message, :attachment => attachment, :friend => target, :options => options)
  end
end


