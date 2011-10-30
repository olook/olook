# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do

  subject { Factory.create(:user) }

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

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }

    it "should validate CPF when required" do
      user = Factory.build(:user)
      user.is_invited = true
      user.save
      user.should be_invalid
    end

    it "should not validate CPF when required" do
      user = Factory.build(:user)
      user.save
      user.should be_valid
    end
  end
  
  describe 'relationships' do
    it { should have_many :points }
    it { should have_one :survey_answer }
    it { should have_many :invites }
    it { should have_many :events }
  end

  context "facebook account" do
    it "should not facebook account" do
      subject.update_attributes(:uid => nil)
      subject.has_facebook?.should == false
    end

    it "should have facebook account" do
      subject.has_facebook?.should == true
    end
  end

  context "survey" do

    it "should find for facebook auth" do
      access_token =  {"extra" => {"user_hash" => {"email" => "mail@mail.com", "first_name" => "Name", "id" => subject.uid}}}
      User.find_for_facebook_oauth(access_token).should == subject
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

  describe "#invite_for" do
    it "should create a new invite for a new and valid e-mail" do
      email = "invited@test.com"
      invite = subject.invite_for(email)
      invite.email.should == email
    end
    it "should return the existing invite for an e-mail which already exists" do
      email = "invited@test.com"
      first_invite = subject.invite_for(email)
      second_invite = subject.invite_for(email)
      first_invite.should == second_invite
    end
    it "should not create an invite for an invalid e-mail" do
      email = "invalid email"
      invite = subject.invite_for(email)
      invite.should be_nil
    end
  end

  describe "#invites_for (plural)" do
    it "should create new invites for new and valid e-mails" do
      emails = ["invited@test.com", "invited2@test.com"]
      new_invites = subject.invites_for(emails)
      new_invites.map(&:email).should =~ emails
    end
    it "should return existing invites for e-mails which already exists" do
      emails = ["invited@test.com", "invited2@test.com"]
      first_invites = subject.invites_for(emails)
      second_invites = subject.invites_for(emails)
      first_invites.map(&:email).should =~ emails
      second_invites.should == first_invites
    end
    it "should not create invites for invalid e-mails" do
      emails = ["invalid  email", "invited@test.com"]
      invites = subject.invites_for(emails)
      invites.should_not be_nil
      invites.map(&:email).should == ["invited@test.com"]
    end
  end

  describe "#accept_invitation_with_token" do
    it "with a valid token" do
      inviting_member = FactoryGirl.create(:member)
      invite = subject.accept_invitation_with_token(inviting_member.invite_token)
      invite.invited_member.should == subject
      invite.accepted_at.should_not be_nil
    end
    it "with an invalid token" do
      expect { subject.accept_invitation_with_token('xxxx') }.to raise_error
    end
  end

  describe "instance methods" do
    it "should return user answers" do
      survey_answers = FactoryGirl.create(:survey_answers, user: subject)
      subject.survey_answers.should == survey_answers.answers
    end
  end
  
  describe "#invite_bonus" do
    describe "when there are no accepted invitations" do
      it 'the invite bonus should be zero' do
        subject.invite_bonus.should be_zero
      end
    end

    describe "when there are accepted invitations, the invite bonus" do
      let(:accepting_member) { FactoryGirl.create(:member, first_name: 'Accepting') }
      let!(:invite) { FactoryGirl.create(:invite, user: subject).accept_invitation(accepting_member) }

      it "should be equal to the amount of accept invites times 10" do
        subject.invite_bonus.should == 10.0
      end
    end
  end
  
  describe "#profile_scores, a user should have a list of profiles based on her survey's results" do
    let(:casual_profile) { FactoryGirl.create(:casual_profile) }
    let(:sporty_profile) { FactoryGirl.create(:sporty_profile) }
    let!(:casual_points) { FactoryGirl.create(:point, user: subject, profile: casual_profile, value: 30) }
    let!(:sporty_points) { FactoryGirl.create(:point, user: subject, profile: sporty_profile, value: 10) }

    it "should include all profiles which scored points" do
      subject.profile_scores.map(&:profile).should =~ [sporty_profile, casual_profile]
    end
    it "the first profile should be the one with most points" do
      main_profile = subject.profile_scores.first
      main_profile.profile.should == casual_profile
      main_profile.value.should == 30
    end
  end
  
  describe "#first_visit? and #record_first_visit" do
    it "should return true if there's no FIRST_VISIT event on the user event list" do
      subject.first_visit?.should be_true
    end
    it "should return false if there's a FIRST_VISIT event on the user event list" do
      subject.record_first_visit
      subject.first_visit?.should be_false
    end
  end
  
  describe "#create_event" do
    it "should add an event for the user" do
      subject.add_event(EventType::SEND_INVITE, 'X invites where sent')
      subject.events.find_by_type(EventType::SEND_INVITE).should_not be_nil
    end
  end
end
