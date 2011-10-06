# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProfileBuilder do

  let(:answer_from_casual_profile) { Factory(:answer_from_casual_profile) }
  let(:answer_from_casual_and_sporty_profile) { Factory(:answer_from_sporty_profile) }

  let(:casual_profile) { Factory(:casual_profile) }
  let(:sporty_profile) { Factory(:sporty_profile) }

  before :each do
    Weight.create(:profile => casual_profile, :answer => answer_from_casual_profile, :weight => 5)
    Weight.create(:profile => casual_profile, :answer => answer_from_casual_and_sporty_profile, :weight => 10)
    Weight.create(:profile => sporty_profile, :answer => answer_from_casual_and_sporty_profile, :weight => 15)

    @questions = { "question_1" => answer_from_casual_profile.id, "question_2" => answer_from_casual_and_sporty_profile.id }
    @user = Factory.create(:user)
    @profile = mock_model('Profile')
    @profile_builder = ProfileBuilder.new(@user)
  end

  it "should build an array of profiles given the answers" do
    expected = [{:profile => casual_profile, :weight => 5}, {:profile => casual_profile, :weight => 10}, {:profile => sporty_profile, :weight => 15}]
    ProfileBuilder.profiles_given_questions(@questions).should == expected
  end

  it "should build an array of profiles given the answers" do
    profiles = ProfileBuilder.profiles_given_questions(@questions)
    expected = {casual_profile.id => 15, sporty_profile.id => 15}
    ProfileBuilder.build_profiles_points(profiles).should == expected
  end

  it "should count and write points" do
    hash = {@profile.id => 2}
    @profile_builder.create_user_points(hash)
    Point.should have(1).record
  end

  it "should not count and write points when already has points" do
    @user.stub(:points).and_return(1)
    hash = {@profile.id => 2}
    @profile_builder.create_user_points(hash)
    Point.should have(0).record
  end

end
