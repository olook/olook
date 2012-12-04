# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Point do
  let(:user) { mock_model(User) }
  let(:profile) { mock_model(Profile) }
  subject { described_class.new(user: user, profile: profile) }

  it "should create a point" do
    Point.create!(value: 10, user: user, profile: profile)
  end
  
  it "#profile_name should return the name of the associated profile" do
    profile.stub(:name).and_return('Some profile')
    subject.profile_name.should == 'Some profile'
  end
end
