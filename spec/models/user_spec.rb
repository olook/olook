 #-*- encoding : utf-8 -*-
require 'spec_helper'

describe User do
  subject { FactoryGirl.create(:user) }

  let(:casual_profile) { FactoryGirl.create(:casual_profile) }
  let(:sporty_profile) { FactoryGirl.create(:sporty_profile) }
  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }
  let(:user_from_campaign) {FactoryGirl.create(:user, email: email)}

  context "when user has a registered campaign email" do
    let(:email) { "test@test.com"}
    let(:campaign_email) { FactoryGirl.create(:campaign_email, email: email) }

    it "find campaign_email" do
      CampaignEmail.should_receive(:find_by_email).with( email ).and_return( campaign_email )
      user_from_campaign
    end

    it "set campaign_email to true" do
      campaign_email
      user_from_campaign
      campaign_email.reload
      campaign_email.converted_user.should be_true
    end

    context "campaign_email_created_at" do
      it "gets populated by CampaignEmail's created_at field" do
        CampaignEmail.should_receive(:find_by_email).with( email ).and_return( campaign_email )
        user = FactoryGirl.create(:user, email: email)
        user.campaign_email_created_at.should eq(campaign_email.created_at)
      end
    end

    context "came_from_campaign_email?" do
      it "indicates that the user came from a campaign email" do
        CampaignEmail.should_receive(:find_by_email).with( email ).and_return( campaign_email )
        user = FactoryGirl.create(:user, email: email)
        user.converted_from_campaign_email?.should be_true
      end
    end
  end

  context "when user doesn't have a registered campaign email" do
    let(:email) { "test@test.com"}
    let(:campaign_email) { FactoryGirl.create(:campaign_email, email: email) }

    context "campaign_email_created_at" do
      it "returns nil" do
        user = FactoryGirl.create(:user, email: "email@test.com")
        user.campaign_email_created_at.should be_nil
      end
    end

    context "converted_from_campaign_email?" do
      it "returns false" do
        user = FactoryGirl.create(:user, email: "email@test.com")
        user.converted_from_campaign_email?.should be_false
      end
    end
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

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }

    describe "when CPF is required" do
      it "should validate" do
        user = FactoryGirl.build(:user)
        user.require_cpf = true
        user.save
        user.should be_invalid
      end

      it "should validate uniqueness" do
        cpf = "19762003691"
        user  = FactoryGirl.create(:user, :cpf => cpf)
        user2 = FactoryGirl.build(:user, :cpf => cpf)
        user2.require_cpf = true
        user2.save
        user2.should be_invalid
      end
    end

    describe "when CPF is not required" do
      it "should not validate" do
        user = FactoryGirl.build(:user)
        user.save
        user.should be_valid
      end
    end
  end

  describe "when gender is required" do
    it "should validate" do
      user = FactoryGirl.build(:user)
      user.half_user = true
      user.save
      user.should be_invalid
    end
  end

  describe "when gender is not required" do
    it "should not validate" do
      user = FactoryGirl.build(:user)
      user.half_user = false
      user.save
      user.should be_valid
    end
  end

  describe 'relationships' do
    it { should have_many :points }
    it { should have_one :survey_answer }
    it { should have_many :invites }
    it { should have_many :events }
    it { should have_one :tracking }
  end

  context "check user's creation" do
    it "should return true if user is new" do
      new_user = FactoryGirl.create(:user)
      new_user.created_at = DateTime.now
      new_user.save
      new_user.is_new?.should be_true
    end

    it "should return true if user is old" do
      subject.is_old?.should be_true
    end

    it "should create a signup event when the user is created" do
      user = FactoryGirl.create(:member)
      user.events.where(:event_type => EventType::SIGNUP).any?.should be_true
    end

    it "enqueues a SignupNotificationWorker in resque" do
      Resque.should_receive(:enqueue).with(SignupNotificationWorker, anything)
      FactoryGirl.create(:member)
    end

    it "adds credit for the invitee" do
      Resque.should_receive(:enqueue_in).with(1.minute, MailRegisteredInviteeWorker, anything)

      FactoryGirl.create(:member, :is_invited => true, :cpf => "19762003691")
    end

  end

  context "facebook_data" do
    let(:id) {"123"}
    let(:token) {"ABC"}
    let(:omniauth) {{"uid" => id, "extra" => {"raw_info" => {"id" => id}}, "credentials" => {"token" => token}}}
    let(:facebook_permissions) {["friends_birthday", "user_birthday" ,"publish_stream", "user_relationships", "user_relationship_details","email"]}

    it "should always set all facebook permissions" do
      subject.should_receive(:update_attributes).with(:uid => id, :facebook_token => token, :facebook_permissions => facebook_permissions)
      subject.set_facebook_data(omniauth)
    end

    it "should set all facebook permissions when user has publish stream permission" do
      session = {:facebook_scopes => "publish_stream"}
      subject.should_receive(:update_attributes).with(:uid => id, :facebook_token => token, :facebook_permissions => facebook_permissions)
      subject.set_facebook_data(omniauth)
    end

    it "should set facebook data with friends birthday permission" do
      session = {:facebook_scopes => "friends_birthday"}
      subject.should_receive(:update_attributes).with(:uid => id, :facebook_token => token, :facebook_permissions => facebook_permissions)
      subject.set_facebook_data(omniauth)
    end

    it "should set facebook data with friends birthday and publish stream permissions" do
      session = {:facebook_scopes => "publish_stream, friends_birthday"}
      subject.should_receive(:update_attributes).with(:uid => id, :facebook_token => token, :facebook_permissions => facebook_permissions)
      subject.set_facebook_data(omniauth)
    end

    it "should add permissions and not remove the old ones" do
      subject.facebook_permissions << "publish_stream"
      subject.save
      session = {:facebook_scopes => "friends_birthday"}
      subject.set_facebook_data(omniauth)
      subject.facebook_permissions.should =~ facebook_permissions
    end

    it "should not duplicate permissions" do
      subject.facebook_permissions << "publish_stream"
      subject.save
      session = {:facebook_scopes => "publish_stream"}
      subject.set_facebook_data(omniauth)
      subject.facebook_permissions.should =~ facebook_permissions
    end

    context "when user is not connected with facebook yet" do
      before do
        subject.stub(:has_facebook?).and_return(false)
      end

      it "receive add_event method" do
        subject.should_receive(:add_event).with(EventType::FACEBOOK_CONNECT)
        subject.set_facebook_data(omniauth)
      end
    end

    context "when user is connected with facebook already" do
      before do
        subject.stub(:has_facebook?).and_return(true)
      end

      it "doesn't receive add_event method" do
        subject.should_not_receive(:add_event)
        subject.set_facebook_data(omniauth)
      end
    end

  end

  context "facebook accounts" do
    it "should not have a facebook account" do
      subject.update_attributes(:uid => nil)
      subject.has_facebook?.should == false
    end

    it "should have a facebook account" do
      subject.has_facebook?.should == true
    end

    it "should access facebook extended features" do
      subject.update_attributes(:has_facebook_extended_permission => true)
      subject.has_facebook_extended_permission?.should be_true
    end

    it "should not access facebook extended features" do
      subject.has_facebook_extended_permission?.should_not be_true
    end
  end

  context "survey" do

    it "should find for facebook auth" do
      User.delete_all
      subject { FactoryGirl.build(:user) }
      access_token =  {"uid" => subject.uid}
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

  describe "invite_for" do
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
  end

  describe "invites_for (plural)" do
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

  describe "inviter" do
    context "when user is not invited by anyone" do
      before do
        subject.update_attribute(:is_invited, false)
      end

      it "returns false" do
        subject.inviter.should be_false
      end
    end

    context "when user is invited by another user" do
      before do
        subject.update_attribute(:is_invited, true)
      end

      it "finds his inviter and return it" do
        inviter = mock(:inviter)
        Invite.should_receive(:find_inviter).with(subject).and_return(inviter)
        subject.inviter.should == inviter
      end
    end
  end

  describe "accept_invitation_with_token" do
    context "with a valid token" do
      let(:inviting_member) { FactoryGirl.create(:member) }
      let(:accepted_invite) { subject.accept_invitation_with_token(inviting_member.invite_token) }

      it "sets the current user as the invited member" do
        accepted_invite.invited_member.should == subject
      end

      it "sets the accepted at field with the current date" do
        accepted_invite.accepted_at.should_not be_nil
      end

    end

    context "with an invalid token" do
      it "raises an error" do
        expect { subject.accept_invitation_with_token('xxxx') }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "surver_answers" do
    it "should return user answers" do
      survey_answers = FactoryGirl.create(:survey_answer, :user => subject)
      subject.survey_answers.should == survey_answers.answers
    end
  end

  describe "profile_scores, a user should have a list of profiles based on her survey's results" do
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

  describe "first_visit?discount_expiration and record_first_visit" do
    it "should return true if there's no FIRST_VISIT event on the user event list" do
      subject.first_visit?.should be_true
    end
    it "should return false if there's a FIRST_VISIT event on the user event list" do
      subject.record_first_visit
      subject.first_visit?.should be_false
    end
  end

  describe "add_event" do
    it "should add an event for the user" do
      subject.add_event(EventType::SEND_INVITE, 'X invites where sent')
      subject.events.find_by_event_type(EventType::SEND_INVITE).should_not be_nil
    end

    context "when the event is a tracking event" do
      it "creates a tracking record for the user with the received hash" do
        subject.add_event(EventType::TRACKING, 'gclid' => 'abc123')
        subject.tracking.gclid.should == 'abc123'
      end

      it "creates a event converting the hash to a string" do
        subject.add_event(EventType::TRACKING, 'gclid' => 'abc123')
        subject.events.find_by_event_type(EventType::TRACKING).description.should == "{\"gclid\"=>\"abc123\"}"
      end
    end
  end

  describe "invitation_url should return a properly formated URL, used when there's no routing context" do
    it "should return with olook.com.br root as default" do
      subject.invitation_url.should == "http://www.olook.com.br/convite/#{subject.invite_token}"
    end

    it "should accept an alternate root" do
      subject.invitation_url('localhost').should == "http://localhost/convite/#{subject.invite_token}"
    end
  end

  describe "main_profile" do
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
    let(:last_collection) { FactoryGirl.create(:collection, :start_date => 1.month.ago, :end_date => Date.today, :is_active => false) }
    let(:collection) { FactoryGirl.create(:collection) }
    let!(:product_a) { FactoryGirl.create(:shoe, :casual, name: 'A', :collection => collection) }
    let!(:product_b) { FactoryGirl.create(:shoe, :casual, name: 'B', :collection => collection) }
    let!(:product_c) { FactoryGirl.create(:shoe, :casual, name: 'C', :collection => collection, :profiles => [sporty_profile], :category => Category::BAG) }
    let!(:product_d) { FactoryGirl.create(:shoe, :casual, name: 'A', :collection => collection, :profiles => [casual_profile, sporty_profile]) }
    let!(:invisible_product) { FactoryGirl.create(:shoe, :casual, :is_visible => false, :collection => collection, :profiles => [sporty_profile]) }
    let!(:casual_points) { FactoryGirl.create(:point, user: subject, profile: casual_profile, value: 10) }
    let!(:sporty_points) { FactoryGirl.create(:point, user: subject, profile: sporty_profile, value: 40) }

    before :each do
      Collection.stub(:current).and_return(collection)
    end

    describe "all_profiles_showroom" do
      it "returns the products ordered by profiles without duplicate names" do
        subject.all_profiles_showroom.should == [product_c, product_d]
      end

      it 'should return only products of the specified category' do
        subject.all_profiles_showroom(Category::BAG).should == [product_c]
      end

      it 'should return an array' do
        subject.all_profiles_showroom.should be_a(Array)
      end

      it 'should return producs given a collection' do
        subject.should_receive(:profile_showroom).at_least(2).times.with(anything, Category::BAG, last_collection).and_return(stub(:all => []))
        subject.all_profiles_showroom(Category::BAG, last_collection)
      end
    end

    describe "profile_showroom" do
      it "should return only the products for the given profile" do
        subject.profile_showroom(sporty_profile).should == [product_c, product_d]
      end

      it 'should return only the products for the given profile and category' do
        subject.profile_showroom(sporty_profile, Category::BAG).should == [product_c]
      end

      it 'should return a scope' do
        subject.profile_showroom(sporty_profile).should be_a(ActiveRecord::Relation)
      end

      it 'should not include the invisible product' do
        subject.profile_showroom(sporty_profile).should_not include(invisible_product)
      end
    end

    describe "main_profile_showroom" do
      it "should return the products ordered by profiles without duplicate names" do
        subject.main_profile_showroom.should == [product_d, product_c]
      end

      it 'should return only the products of a given category' do
        subject.main_profile_showroom(Category::BAG).should == [product_c]
      end

      it 'should return an array' do
        subject.main_profile_showroom.should be_a(Array)
      end
    end

    describe "birthdate" do
      it "returns formatted birthday string" do
        subject.birthday = Date.new(1975,10,3)
        subject.save!
        subject.birthdate.should == "03/10/1975"
      end

      it "returns nil if no birthday is provided" do
        subject.birthday = nil
        subject.save!
        subject.birthdate.should be_nil
      end
    end

    describe "age" do
      context "when user birthday is not defined" do
        it "returns nil" do
          subject.stub(:age).and_return(nil)
          subject.age.should be_nil
        end
      end

      context "when user birthday is defined and today is 2013-07-13" do
        before do
          Date.should_receive(:today).and_return(Date.new(2013,7,13))
        end

        context "and user birthday is 1983-07-18" do
          it "returns 29" do
            subject.stub(:birthday).and_return(Date.new(1983,7,18))
            subject.age.should == 29
          end
        end

        context "and user birthday is 1983-07-13" do
          it "returns 30" do
            subject.stub(:birthday).and_return(Date.new(1983,7,13))
            subject.age.should == 30
          end
        end

        context "and user birthday is 2013-10-13" do
          it "returns 30" do
            subject.stub(:birthday).and_return(Date.new(1983,5,13))
            subject.age.should == 30
          end
        end
      end
    end

    describe "profile_name" do
      it "returns english profile symbol name" do
        subject.profile_name.should == :sporty
      end
    end

    describe 'remove_color_variations' do
      let(:shoe_a_black)  { double :shoe, name: 'Shoe A', :'sold_out?' => false, inventory: 10 }
      let(:shoe_a_red)    { double :shoe, name: 'Shoe A', :'sold_out?' => false, inventory: 5 }
      let(:shoe_b_green)  { double :shoe, name: 'Shoe B', :'sold_out?' => false, inventory: 4 }
      let(:products)      { [shoe_a_black, shoe_b_green, shoe_a_red] }

      context 'when no product is sold out' do
        it 'should return only one color for products with the same name' do
          Product.remove_color_variations(products).should == [shoe_a_black, shoe_b_green]
        end
      end

      context 'when the first product in a color set is sold out' do
        before :each do
          shoe_a_black.stub(:'sold_out?').and_return(true)
        end
        it 'should return the second color in the place of the sold out one' do
          Product.remove_color_variations(products).should == [shoe_a_red, shoe_b_green]
        end
      end

      context 'when the second product in a color set is sold out' do
        before :each do
          shoe_a_red.stub(:'sold_out?').and_return(true)
        end
        it 'should return the first color and hide the one sold out' do
          Product.remove_color_variations(products).should == [shoe_a_black, shoe_b_green]
        end
      end
    end
  end

  describe 'has_purchases?' do
    context 'when user has no orders' do

      it 'returns false' do
        subject.has_purchases?.should be_false
      end
    end

    context 'when user has one order in the cart' do
      it 'returns false' do
        FactoryGirl.create(:cart_with_items, :user => subject)
        subject.has_purchases?.should be_false
      end
    end

    context 'when user has one order not in the cart' do
      it 'returns true' do
        order = FactoryGirl.create(:order, :user => subject)
        subject.has_purchases?.should be_true
      end
    end
  end

  describe "current_credit" do
    context "when user has no credits" do
      it "returns 0" do
        subject.current_credit.should == 0
      end
    end

    context "when user has one credit record" do
      it "returns the total of the credit record" do
        subject.user_credits_for(:invite).add(:amount => 10.0)
        subject.current_credit.should == subject.user_credits_for(:invite).total
      end
    end

    context "when user has more than one credit record" do
      it "returns the total of the last credit record" do
        subject.user_credits_for(:invite).add(:amount => 10.0)
        subject.user_credits_for(:redeem).add(:amount => 10.0, :admin_id => subject.id)
        subject.reload.current_credit.should == 20.0
      end
    end

  end

  describe "can_use_credit?" do
    before do
      subject.user_credits_for(:invite).add(:amount => 23.0)
    end

    context "when user current credits is less then the received value" do
      it "returns false" do
        subject.can_use_credit?(23.01).should be_false
      end
    end

    context "when user current credits is equal to the received value" do
      it "returns true" do
        subject.can_use_credit?(23.00).should be_true
      end
    end

    context "when user current credit is greather than the received value" do
      it "returns true" do
        subject.can_use_credit?(21.90).should be_true
      end
    end
  end

  describe "#has_purchased_orders?" do

    context "when user has no orders" do
      it "returns false" do
        subject.has_purchased_orders?.should be_false
      end
    end

    context "when user has orders" do
      let(:order) { FactoryGirl.create(:order, :user => subject) }

      context "when user has 1 authorized order" do
        it "returns true" do
          order.authorized
          subject.has_purchased_orders?.should be_true
        end
      end
    end

  end

  describe "#first_buy?" do

    context "when user has no orders" do
      it "returns false" do
        subject.first_buy?.should be_false
      end
    end

    context "when user has orders" do
      let(:order) { FactoryGirl.create(:authorized_order, :user => subject) }

      context "when user has one order in the cart" do
        it "returns false" do
          subject.first_buy?.should be_false
        end
      end

      context "when user has one order waiting payment" do
        it "returns false" do
          subject.first_buy?.should be_false
        end
      end

      context "when user has one order authorized" do
        it "returns true" do
          order.authorized
          subject.first_buy?.should be_true
        end
      end

      context "when user has one order being picked" do
        it "returns true" do
          order.authorized
          order.picking
          subject.first_buy?.should be_true
        end
      end

      context "when user has one order being delivered" do
        it "returns true" do
          order.authorized
          order.picking
          order.delivering
          subject.first_buy?.should be_true
        end
      end

      context "when user has one order under review" do
        it "returns true" do
          order.authorized
          order.under_review
          subject.first_buy?.should be_true
        end
      end

      context "when user has two orders authorized" do
        let(:second_order) { FactoryGirl.create(:authorized_order, :user => subject) }

        it "returns false" do
          order.authorized
          second_order.authorized
          subject.first_buy?.should be_false
        end
      end
    end
  end

  describe "tracking_params" do

    let!(:tracking_params) do
      {
        "utm_source" => "midiasproprias",
        "utm_medium" => "facebook",
        "utm_content" => "infopage",
        "utm_campaign" => "stylequiz"
      }
    end

    context "when the user has no tracking event" do
      before do
        subject.events.destroy_all
      end

      it "returns nil" do
        subject.tracking_params("utm_source").should be_nil
      end
    end

    context "when the user has a tracking event" do
      before do
        subject.events.destroy_all
        subject.add_event(EventType::TRACKING, tracking_params.to_s)
      end

      context "and the passed param name exists in the tracking data" do
        it "returns the correct value for the passed param" do
          tracking_params.each do |param,value|
            subject.tracking_params(param).should == value
          end
        end
      end

      context "and the passed param name does not exist in the tracking data" do
        it "returns nil" do
          subject.tracking_params("invalid").should be_nil
        end
      end

    end

    context "when the user has two tracking events" do
      before do
        subject.events.destroy_all
        subject.add_event(EventType::TRACKING, "")
        subject.add_event(EventType::TRACKING, tracking_params.to_s)
      end

      it "considers only the data from the first tracking event" do
        subject.tracking_params("utm_source").should be_nil
      end
    end
  end

  describe '#valid_password?' do
    subject { FactoryGirl.build(:user, @attrs).valid_password?(@password) }
    context 'when user has_fraud' do
      before do
        @attrs = { has_fraud: true, password: 'asdfasdf', password_confirmation: 'asdfasdf' }
        @password = 'asdfasdf'
      end
      it { should be_false }
      it 'should call Rails.logger.info with block info' do
        Rails.logger.should_receive(:info)
        subject
      end
    end

    context 'when user has not fraud' do
      before do
        @attrs = { has_fraud: false, password: 'asdfasdf', password_confirmation: 'asdfasdf' }
        @password = 'asdfasdf'
      end
      it { should be_true }
      it 'should not call Rails.logger.info with block info' do
        Rails.logger.should_not_receive(:info)
        subject
      end
    end
  end
end
