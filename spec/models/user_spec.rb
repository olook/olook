# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do

  subject { Factory.create(:user) }

  before :each do
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
end
