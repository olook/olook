# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do

  before :each do
    @user = Factory.create(:user)
    @profile = mock_model('Profile')
  end

  context "attributes validation" do

    it { should allow_value("a@b.com").for(:email) }
    it { should_not allow_value("@b.com").for(:email) }
    it { should_not allow_value("a@b.").for(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should allow_value("José").for(:first_name) }
    it { should allow_value("José Bar").for(:first_name) }

    it { should_not allow_value("José_Bar").for(:first_name) }
    it { should_not allow_value("123").for(:first_name) }

    it { should allow_value("José").for(:last_name) }
    it { should allow_value("José Bar").for(:last_name) }

    it { should_not allow_value("José_Bar").for(:last_name) }
    it { should_not allow_value("123").for(:last_name) }

  end

  it "should count and write points" do
    hash = {@profile.id => 2}
    @user.counts_and_write_points(hash)
    Point.should have(1).record
  end

  it "should not count and write points when already has points" do
    @user.stub(:points).and_return(1)
    hash = {@profile.id => 2}
    @user.counts_and_write_points(hash)
    Point.should have(0).record
  end

  context "survey" do

    let(:access_token) { {"extra" => {"user_hash" => {"email" => "mail@mail.com", "first_name" => "Name"}}} }
    let(:profile_points) { {:foo => :bar} }

    before :each do
      @survey_answer = SurveyAnswer.new(:answers => {:foo => :bar})
    end

    it "should create a SurveyAnswer" do
      expect {
            User.find_for_facebook_oauth(access_token, @survey_answer, profile_points)
          }.to change(SurveyAnswer, :count).by(1)
    end

    it "should return the user" do
      access_token = {"extra" => {"user_hash" => {"email" => @user.email, "first_name" => @user.first_name}}}
      user = User.find_for_facebook_oauth(access_token, @survey_answer, profile_points)[0]
      user.should == @user
    end

    it "should return the a empty user" do
      user = User.find_for_facebook_oauth(access_token, @survey_answer, nil)[0]
      user.should == ""
    end

  end

  context "invite token" do
    subject { FactoryGirl.build(:user, :first_name => 'Member Jane', :email => 'member.jane@mail.com') }

    it "should be empty when built" do
      subject.invite_token.should be_nil
    end

    it "should be non-empty when saved" do
      subject.save!
      subject.invite_token.should_not be_nil
    end

    it "should keep the same token even saved more than once" do
      subject.save!
      original_token = subject.invite_token
      subject.invite_token.should_not be_nil

      subject.save!
      subject.invite_token.should == original_token
    end

    it "should be read-only" do
      subject.save!
      expect { subject.invite_token = "foo" }.to raise_error
    end
  end
end
