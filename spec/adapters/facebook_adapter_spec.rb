# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FacebookAdapter do
  subject { FacebookAdapter.new(:fake_access_token) }
  let(:friend_list) { [{"id" => "1", "name" => "User name 1"}, {"id" => "2", "name" => "User name 2"}] }
  let(:formated_friend_list) { [OpenStruct.new(:uid => "1", :name => "User name 1"), OpenStruct.new(:uid => "2", :name => "User name 2")] }

  it "should get the friend list" do
    subject.adapter.should_receive(:get_connections).at_least(2).times.with("me", "friends").and_return(friend_list)
    subject.facebook_friends.first.uid.should == "1"
    subject.facebook_friends.first.name.should == "User name 1"
  end

  it "should get the friends ids list" do
    subject.stub(:facebook_friends).and_return(formated_friend_list)
    subject.facebook_friends_ids.should == ["1", "2"]
  end

  it "should get the facebook friends registered at olook" do
    subject.stub(:facebook_friends_ids).and_return(friends_ids = ["1", "2"])
    User.should_receive(:find_all_by_uid).with(friends_ids)
    subject.facebook_friends_registered_at_olook
  end

  it "should get the facebook friends not registered at olook" do
    subject.stub(:facebook_friends_registered_at_olook).and_return([OpenStruct.new(:uid => "1", :name => "User name 1")])
    subject.stub(:facebook_friends).and_return(formated_friend_list)
    subject.facebook_friends_not_registered_at_olook.should == [formated_friend_list.last]
  end

  it "should post a message in the wall" do
    message, attachment, target, options = :message, {}, "me", {}
    subject.adapter.should_receive(:put_wall_post).with(message, attachment, target, options)
    subject.post_wall_message(message, :attachment => attachment, :friend => target, :options => options)
  end
end


