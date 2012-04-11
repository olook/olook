# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProfileBuilder do

  let(:survey) { FactoryGirl.create(:survey) }
  let(:question) { FactoryGirl.create(:question, :survey => survey) }

  let!(:answer_from_casual_profile) { FactoryGirl.create(:answer_from_casual_profile, :question => question) }
  let!(:answer_from_casual_and_sporty_profile) { FactoryGirl.create(:answer_from_sporty_profile, :question => question) }

  let!(:casual_profile) { FactoryGirl.create(:casual_profile) }
  let!(:sporty_profile) { FactoryGirl.create(:sporty_profile) }

  before :each do
    Weight.create(:profile => casual_profile, :answer => answer_from_casual_profile, :weight => 5)
    Weight.create(:profile => casual_profile, :answer => answer_from_casual_and_sporty_profile, :weight => 10)
    Weight.create(:profile => sporty_profile, :answer => answer_from_casual_and_sporty_profile, :weight => 15)

    @questions = { "question_1" => answer_from_casual_profile.id, "question_2" => answer_from_casual_and_sporty_profile.id }
    @user = FactoryGirl.create(:user)
    @profile = mock_model('Profile')
    @profile2 = mock_model('Profile')
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

  it "should save the correct points" do
    hash = {@profile.id => 2, @profile2.id => 3}
    @profile_builder.create_user_points(hash)
    @user.points.first.profile_id.should == @profile.id
    @user.points.last.profile_id.should  == @profile2.id
  end

  context "#first_profile_given_questions" do
    let(:profile_questions) { [{:profile => casual_profile, :weight => 5}] }
    let(:profile_points) { { 1 => 20, 2 => 13, 10 => 210, 4 => 215, 7 => 94} }

    it "gets profiles_given_questions" do
      Profile.stub(:find)
      described_class.should_receive(:profiles_given_questions).with(@questions).and_return(profile_questions)
      described_class.first_profile_given_questions(@questions)
    end

    it "gets profiles points" do
      Profile.stub(:find)
      described_class.stub(:profiles_given_questions).and_return(profile_questions)
      described_class.should_receive(:build_profiles_points).with(profile_questions).and_return(profile_points)
      described_class.first_profile_given_questions(@questions)
    end

    it "tries to get the profile name with the highest score" do
      profile = double(:profile)
      described_class.stub(:profiles_given_questions)
      described_class.stub(:build_profiles_points).and_return(profile_points)

      Profile.should_receive(:find).with(4).and_return(profile)
      profile.should_receive(:try).with(:name).and_return("Fashion")
      described_class.first_profile_given_questions(@questions).should == "Fashion"
    end
  end
end
