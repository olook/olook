# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserCredit do
  it { should belong_to(:user) }
  it { should belong_to(:credit_type) }
  it { should have_many(:credits) }

  describe "when basic methods are being tested" do
    after do
      Delorean.back_to_the_present
    end

    let(:user) { FactoryGirl.create(:member) }
    let(:credit_type){ mock_model(CreditType, :total => 25.03, :add => true, :remove => true) }
    let(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => credit_type) }
    let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
    let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
    let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }
    let(:order) { FactoryGirl.create(:order, :user => user) }
    let(:invitee) { FactoryGirl.create(:user, :is_invited => true, :cpf => '298.161.997-77') }
    let(:invite) { FactoryGirl.create(:invite, :user => user) }
    let(:amount) { BigDecimal.new('22.03')}
    let(:credit_attrs) {{:amount => amount,:order => order}}
    let(:merged_credit_attrs) do
      {
        :order => order,
        :user_credit => user_credit,
        :value => amount
      }
    end
    
    it "should run the total method" do
      date_time = DateTime.now
      user_credit.credit_type.should_receive(:total).with(user_credit, date_time, :available, anything).and_return(25.03)
      user_credit.total(date_time).should eq(25.03)
    end

    it "should run the add method" do
      order = Order.new
      user_credit.credit_type.should_receive(:add).with(merged_credit_attrs.merge({:total => (user_credit.total + amount)})).and_return(true)
      user_credit.add(credit_attrs.dup).should eq(true)
    end

    it "should run the process method" do
      FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type)
      FactoryGirl.create(:user_credit, :credit_type => invite_credit_type)
      invite.accept_invitation(invitee)

      invitee_order = FactoryGirl.create(:order, :user => invitee, :state => 'delivered')

      UserCredit.process!(invitee_order)

      invitee.user_credits_for(:loyalty_program).total.should eq(20.00)
      user.user_credits_for(:invite).total.should == BigDecimal.new(Setting.invite_credits_bonus_for_inviter)

    end

    context "when User Credit specific settings change" do
      context "when invite_credits_available is disabled" do
        it "doesn't run add_loyalty_program_credits " do

          FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type)
          FactoryGirl.create(:user_credit, :credit_type => invite_credit_type)
          
          Setting.stub(:loyalty_program_credits_available).and_return false

          # UserCredit.should_receive(:add_invite_credits)
          # Resque.should_receive(:enqueue_in).with(1.minute, MailRegisteredInviteeWorker, anything)
          # Resque.should_receive(:enqueue_in).with(1.minute, Abacos::InsertOrder, anything)
          # Resque.should_receive(:enqueue_in).with(1.minute, Orders::NotificationOrderRequestedWorker, anything)
          # Resque.should_receive(:enqueue_in).with(1.minute, MailProductPurchasedByInviteeWorker, anything)
          UserCredit.should_not_receive(:add_loyalty_program_credits)

          invite.accept_invitation(invitee)

          invitee_order = FactoryGirl.create(:order, :user => invitee, :state => 'delivered')

          UserCredit.process!(invitee_order)
        end
      end

      it "should not run the add_loyalty_program_credits method when loyalty_program_credits_available is disabled" do

        FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type)
        FactoryGirl.create(:user_credit, :credit_type => invite_credit_type)

        Setting.invite_credits_available = false

        UserCredit.should_not_receive(:add_invite_credits)
        UserCredit.should_receive(:add_loyalty_program_credits)

        invite.accept_invitation(invitee)

        invitee_order = FactoryGirl.create(:order, :user => invitee, :state => 'delivered')

        UserCredit.process!(invitee_order)

        Setting.invite_credits_available = true

      end
    end

  end

end
