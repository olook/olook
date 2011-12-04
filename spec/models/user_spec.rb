# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do
  subject { Factory.create(:user) }

  let(:casual_profile) { FactoryGirl.create(:casual_profile) }
  let(:sporty_profile) { FactoryGirl.create(:sporty_profile) }

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

    describe "when CPF is required" do
      it "should validate" do
        user = Factory.build(:user)
        user.is_invited = true
        user.save
        user.should be_invalid
      end

      it "should validate uniqueness" do
        cpf = "19762003691"
        user  = FactoryGirl.create(:user, :cpf => cpf)
        user2 = FactoryGirl.build(:user, :cpf => cpf)
        user2.is_invited = true
        user2.save
        user2.should be_invalid
      end
    end

    describe "when CPF is not required" do
      it "should not validate" do
        user = Factory.build(:user)
        user.save
        user.should be_valid
      end
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
    let(:valid_email) { "invited@test.com" }

    it "should create a new invite for a new and valid e-mail" do
      invite = subject.invite_for(valid_email)
      invite.email.should == valid_email
    end

    it "should return the existing invite for an e-mail which already exists" do
      first_invite = subject.invite_for(valid_email)
      second_invite = subject.invite_for(valid_email)
      first_invite.should == second_invite
    end

    it "should not create an invite for an invalid e-mail" do
      email = "invalid email"
      invite = subject.invite_for(email)
      invite.should be_nil
    end

    it "should not create an invite for an existing user" do
      valid_user = FactoryGirl.create(:member)
      invite = subject.invite_for(valid_user.email)
      invite.should be_nil
    end
  end

  describe "#invites_for (plural)" do
    it "should create new invites with limit for new and valid e-mails" do
      emails = ["invited@test.com", "invited2@test.com", "invited2@test.com"]
      limit, expected_size = 1, 2
      new_invites = subject.invites_for(emails, limit)
      new_invites.size.should == expected_size
    end
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

  it "#invite_bonus, should relay on InviteBonus" do
    InviteBonus.should_receive(:calculate).with(subject).and_return(123.0)
    subject.invite_bonus.should == 123.0
  end

  describe "#profile_scores, a user should have a list of profiles based on her survey's results" do
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

  describe "#add_event" do
    it "should add an event for the user" do
      subject.add_event(EventType::SEND_INVITE, 'X invites where sent')
      subject.events.find_by_event_type(EventType::SEND_INVITE).should_not be_nil
    end
  end
  
  describe "#invitation_url should return a properly formated URL, used when there's no routing context" do
    it "should return with olook.com.br root as default" do
      subject.invitation_url.should == "http://olook.com.br/convite/#{subject.invite_token}"
    end

    it "should accept an alternate root" do
      subject.invitation_url('localhost').should == "http://localhost/convite/#{subject.invite_token}"
    end
  end

  describe "#main_profile" do
    let(:mock_point_a) { mock_model Point, :profile => :first_profile }
    let(:mock_point_b) { mock_model Point, :profile => :second_profile }

    it 'should return the user main profile when it exists' do
      subject.stub(:profile_scores).and_return([mock_point_a, mock_point_b])
      subject.main_profile.should == :first_profile
    end
    it "should return nil if the doesn't have a profile" do
      subject.stub(:profile_scores).and_return([])
      subject.main_profile.should == nil
    end
  end

  describe "showroom methods" do
    let(:collection) { FactoryGirl.create(:collection) }
    let!(:casual_product_a) { FactoryGirl.create(:basic_shoe, :collection => collection, :profiles => [casual_profile]) }
    let!(:casual_product_b) { FactoryGirl.create(:basic_shoe, :collection => collection, :profiles => [casual_profile]) }
    let!(:sporty_product_a) { FactoryGirl.create(:basic_shoe, :collection => collection, :profiles => [sporty_profile], :category => Category::BAG) }
    let!(:sporty_product_b) { FactoryGirl.create(:basic_shoe, :collection => collection, :profiles => [sporty_profile]) }

    let!(:casual_points) { FactoryGirl.create(:point, user: subject, profile: casual_profile, value: 10) }
    let!(:sporty_points) { FactoryGirl.create(:point, user: subject, profile: sporty_profile, value: 40) }

    before :each do
      Collection.stub(:current).and_return(collection)
    end

    describe "#all_profiles_showroom" do
      it "should return the products ordered by profiles" do
        subject.all_profiles_showroom.should == [sporty_product_a, sporty_product_b, casual_product_a, casual_product_b]
      end
    
      it 'should return only products of the specified category' do
        subject.all_profiles_showroom(Category::BAG).should == [sporty_product_a]
      end
      
      it 'should return an array' do
        subject.all_profiles_showroom.should be_a(Array)
      end
    end
    
    describe "#profile_showroom" do
      it "should return only the products for the given profile" do
        subject.profile_showroom(sporty_profile).should == [sporty_product_a, sporty_product_b]
      end
    
      it 'should return only the products for the given profile and category' do
        subject.profile_showroom(sporty_profile, Category::BAG).should == [sporty_product_a]
      end

      it 'should return a scope' do
        subject.profile_showroom(sporty_profile).should be_a(ActiveRecord::Relation)
      end
    end

    describe "#main_profile_showroom" do
      before :each do
        subject.stub(:main_profile).and_return(sporty_profile)
      end

      it "should return only the products for the main profile" do
        subject.main_profile_showroom.should == [sporty_product_a, sporty_product_b]
      end
    
      it 'should return only the products of a given category for the main profile' do
        subject.main_profile_showroom(Category::BAG).should == [sporty_product_a]
      end

      it 'should return a scope' do
        subject.main_profile_showroom.should be_a(ActiveRecord::Relation)
      end
    end
  end
  
end
