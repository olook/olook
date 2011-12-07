# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserObserver do
  it "should create a signup event when the user is created" do
    user = FactoryGirl.create(:member)
    user.events.where(:event_type => EventType::SIGNUP).any?.should be_true
  end
end
