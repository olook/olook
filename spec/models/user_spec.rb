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

    it "should validate CPF when required" do
      user = Factory.build(:user)
      user.require_cpf = true
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
      @user.has_facebook?.should == false
    end

    it "should have facebook account" do
      @user.update_attributes(:uid => "123")
      @user.has_facebook?.should == true
    end

  end

  context "survey" do

    let(:access_token) { {"extra" => {"user_hash" => {"email" => "mail@mail.com", "first_name" => "Name"}}} }

    it "should find for facebook auth" do
      User.should_receive(:find_by_uid).with(access_token["extra"]["user_hash"]["id"])
      User.find_for_facebook_oauth(access_token)
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
  
  describe "#create_invite_for" do
    it "with a new e-mail" do
      email = "invited@test.com"
      invite = subject.invite_for(email)
      invite.email.should == email
    end
    it "with an existing e-mail" do
      email = "invited@test.com"
      first_invite = subject.invite_for(email)
      second_invite = subject.invite_for(email)
      first_invite.should == second_invite
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

  describe "#invite_by_email" do
    it "when receiving a list of e-mails" do
      emails = ['jane@friend.com', 'linda@friend.com', 'mary@friend.com']

      subject.invites.should be_empty
      new_invites = subject.invite_by_email emails
      new_invites.map(&:email).should =~ emails.reverse
    end
    it "when receiving a list with invalid e-mails" do
      emails = ['jane@friend.com', 'invalid email format', 'mary@friend.com']

      subject.invites.should be_empty
      new_invites = subject.invite_by_email emails
      new_invites.map(&:email).should =~ ['jane@friend.com', 'mary@friend.com']
    end
    it "when receiving an empty list of e-mails" do
      emails = []

      subject.invites.should be_empty
      subject.invite_by_email emails
      subject.invites.should be_empty
    end
  end
end
