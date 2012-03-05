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
    it { should have_one :tracking }
  end

  context "check user's creation" do
    it "should return true if user is new" do
      new_user = Factory.create(:user)
      new_user.created_at = DateTime.now
      new_user.save
      new_user.is_new?.should be_true
    end

    it "should return true if user is old" do
      subject.is_old?.should be_true
    end
  end

  context "#facebook_data" do
    let(:id) {"123"}
    let(:token) {"ABC"}
    let(:omniauth) {{"uid" => id, "extra" => {"raw_info" => {"id" => id}}, "credentials" => {"token" => token}}}

    it "should set facebook data with a extended permission" do
      session = {:facebook_scopes => "publish_stream"}
      subject.should_receive(:update_attributes).with(:uid => id, :facebook_token => token, :has_facebook_extended_permission => true)
      subject.set_facebook_data(omniauth, session)
    end

    it "should set facebook data without extended permission" do
      session = {:facebook_scopes => nil}
      subject.should_receive(:update_attributes).with(:uid => id, :facebook_token => token)
      subject.set_facebook_data(omniauth, session)
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

  describe "instance methods" do
    it "should return user answers" do
      survey_answers = FactoryGirl.create(:survey_answers, user: subject)
      subject.survey_answers.should == survey_answers.answers
    end
  end

  describe "#invite_bonus" do
    it "calls calculate on InviteBonus and returns the value" do
      InviteBonus.should_receive(:calculate).with(subject).and_return(123.0)
      subject.invite_bonus.should == 123.0
    end
  end

  describe "#used_invite_bonus" do
    it "calls already_used on InviteBonus and returns the value" do
      InviteBonus.should_receive(:already_used).with(subject).and_return(13.0)
      subject.used_invite_bonus.should == 13.0
    end
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

  describe "#has_early_access?" do
    it 'should always return true' do
      subject.has_early_access?.should be_true
    end
  end

  describe "#add_event" do
    it "should add an event for the user" do
      subject.add_event(EventType::SEND_INVITE, 'X invites where sent')
      subject.events.find_by_event_type(EventType::SEND_INVITE).should_not be_nil
    end

    context "when the event is a tracking event" do
      it "should create a tracking record for the user with the received hash" do
        subject.add_event(EventType::TRACKING, 'gclid' => 'abc123')
        subject.tracking.gclid.should == 'abc123'
      end
    end
  end

  describe "#invitation_url should return a properly formated URL, used when there's no routing context" do
    it "should return with olook.com.br root as default" do
      subject.invitation_url.should == "http://www.olook.com.br/convite/#{subject.invite_token}"
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
    let!(:product_a) { FactoryGirl.create(:basic_shoe, :name => 'A', :collection => collection, :profiles => [casual_profile]) }
    let!(:product_b) { FactoryGirl.create(:basic_shoe, :name => 'B', :collection => collection, :profiles => [casual_profile]) }
    let!(:product_c) { FactoryGirl.create(:basic_shoe, :name => 'C', :collection => collection, :profiles => [sporty_profile], :category => Category::BAG) }
    let!(:product_d) { FactoryGirl.create(:basic_shoe, :name => 'A', :collection => collection, :profiles => [casual_profile, sporty_profile]) }

    let!(:invisible_product) { FactoryGirl.create(:basic_shoe, :is_visible => false, :collection => collection, :profiles => [sporty_profile]) }

    let!(:casual_points) { FactoryGirl.create(:point, user: subject, profile: casual_profile, value: 10) }
    let!(:sporty_points) { FactoryGirl.create(:point, user: subject, profile: sporty_profile, value: 40) }

    before :each do
      Collection.stub(:current).and_return(collection)
    end

    describe "#all_profiles_showroom" do
      it "should return the products ordered by profiles without duplicate names" do
        subject.all_profiles_showroom.should == [product_c, product_d, product_b]
      end

      it 'should return only products of the specified category' do
        subject.all_profiles_showroom(Category::BAG).should == [product_c]
      end

      it 'should return an array' do
        subject.all_profiles_showroom.should be_a(Array)
      end
    end

    describe "#profile_showroom" do
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

    describe "#main_profile_showroom" do
      before :each do
        subject.stub(:main_profile).and_return(sporty_profile)
      end

      it "should return only the products for the main profile" do
        subject.main_profile_showroom.should == [product_c, product_d]
      end

      it 'should return only the products of a given category for the main profile' do
        subject.main_profile_showroom(Category::BAG).should == [product_c]
      end

      it 'should return a scope' do
        subject.main_profile_showroom.should be_a(Array)
      end
    end

    describe "#birthdate" do
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

    describe "#profile_name" do
      it "returns english profile symbol name" do
        subject.profile_name.should == :sporty
      end
    end

    describe '#remove_color_variations' do
      let(:shoe_a_black)  { double :shoe, :name => 'Shoe A', :'sold_out?' => false }
      let(:shoe_a_red)    { double :shoe, :name => 'Shoe A', :'sold_out?' => false }
      let(:shoe_b_green)  { double :shoe, :name => 'Shoe B', :'sold_out?' => false }
      let(:products)      { [shoe_a_black, shoe_b_green, shoe_a_red] }

      context 'when no product is sold out' do
        it 'should return only one color for products with the same name' do
          subject.send(:remove_color_variations, products).should == [shoe_a_black, shoe_b_green]
        end
      end

      context 'when the first product in a color set is sold out' do
        before :each do
          shoe_a_black.stub(:'sold_out?').and_return(true)
        end
        it 'should return the second color in the place of the sold out one' do
          subject.send(:remove_color_variations, products).should == [shoe_a_red, shoe_b_green]
        end
      end

      context 'when the second product in a color set is sold out' do
        before :each do
          shoe_a_red.stub(:'sold_out?').and_return(true)
        end
        it 'should return the first color and hide the one sold out' do
          subject.send(:remove_color_variations, products).should == [shoe_a_black, shoe_b_green]
        end
      end
    end
  end

  describe '#has_purchases?' do
    context 'when user has no orders' do

      it 'returns false' do
        subject.has_purchases?.should be_false
      end
    end

    context 'when user has one order in the cart' do
      it 'returns false' do
        Factory.create(:order_without_payment, :user => subject)
        subject.has_purchases?.should be_false
      end
    end

    context 'when user has one order not in the cart' do
      it 'returns true' do
        order = Factory.create(:order, :user => subject)
        order.waiting_payment
        subject.has_purchases?.should be_true
      end
    end
  end

  describe "#tracking_params" do

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

  describe "#total_revenue" do
    context "when user has no purchases" do
      it "returns 0" do
        subject.total_revenue.should == 0
      end
    end

    context "when the user has one purchase in the cart" do
      before do
        FactoryGirl.create(:order_without_payment, :user => subject)
      end

      it "returns 0" do
        subject.total_revenue.should == 0
      end
    end

    context "when the user has one completed order" do
      let(:order) do
        FactoryGirl.create(:order, :user => subject)
      end

      before do
        order.payment.billet_printed
        order.payment.authorized
      end

      it "returns the value of this order" do
        Order.any_instance.should_receive(:total).and_return(BigDecimal.new("100"))
        subject.total_revenue.to_s.should == "100.0"
      end
    end

    context "when the user has two completed order" do
      let(:order_one) do
        FactoryGirl.create(:order, :user => subject)
      end

      let(:order_two) do
        FactoryGirl.create(:order, :user => subject)
      end

      before do
        order_one.payment.billet_printed
        order_one.payment.authorized
        order_two.payment.billet_printed
        order_two.payment.authorized
      end

      it "returns the total sum of the orders" do
        Order.any_instance.stub(:total).and_return(BigDecimal.new("53.34"))
        subject.total_revenue.to_s.should == "106.68"
      end
    end

    context "when called with total_with_freight" do
      let(:order) do
        FactoryGirl.create(:order, :user => subject)
      end

      before do
        order.payment.billet_printed
        order.payment.authorized
      end

      it "calls total_with_freight on the order" do
        Order.any_instance.should_receive(:total_with_freight).and_return(0)
        subject.total_revenue(:total_with_freight)
      end
    end
  end
end
