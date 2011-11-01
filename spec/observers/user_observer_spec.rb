# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserObserver do
  it "should create a signup event when the user is created" do
    User.any_instance.should_receive(:add_event).with(EventType::SIGNUP)
    FactoryGirl.create(:member)
  end
end
