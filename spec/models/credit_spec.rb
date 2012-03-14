# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Credit do
  it { should belong_to(:user) }
  it { should belong_to(:order) }
  it { should validate_presence_of(:value) }

  let(:user) { FactoryGirl.create(:member) }

  describe "adding invite bonus for invited user (invitee)" do

    context "when user is not invited" do
      before do
        user.update_attribute(:is_invited,false)
      end

      it "does not change user credits" do
        expect {
          described_class.add_for_invitee(user)
        }.to_not change(user, :current_credit)
      end
    end

    context "and user is invited" do
      before do
        user.update_attribute(:is_invited,true)
      end

      context "when user has already some credit" do
        before do
          FactoryGirl.create(:credit, :user => user)
        end

        it "does not change user credits" do
          expect {
            described_class.add_for_invitee(user)
          }.to_not change(user, :current_credit)
        end
      end

      context "when user has no credits" do
        before do
          user.credits.destroy_all
        end

        it "adds 10.00 worth of invite bonus credits to the user" do
          expect {
            described_class.add_for_invitee(user)
          }.to change(user, :current_credit).by(10)
        end

        it "creates a record with invite_bonus source" do
          described_class.add_for_invitee(user)
          user.credits.last.source.should == "inviter_bonus"
        end
      end
    end
  end

  describe "adding bonus for a inviter after invitee completes an order" do
    let(:inviter) { FactoryGirl.create(:member) }
    let(:order) {FactoryGirl.create(:order, :user => user)}

    context "when the user is not invited" do
      before do
        user.update_attribute(:is_invited,false)
      end

      it "does not change user current_credit" do
        expect {
            described_class.add_for_inviter(user, order)
          }.to_not change(inviter, :current_credit)
      end

      it "returns false" do
        described_class.add_for_inviter(user, order).should be_false
      end
    end

    context "when the user is invited (accepted and invitation from an inviter)" do
      let(:invite) { FactoryGirl.create(:invite, :user => inviter)}

      before do
        invite.accept_invitation(user)
        user.update_attribute(:is_invited,true)
      end

      context "and user is doing his first buy" do
        before do
          user.stub(:first_buy?).and_return(true)
        end

        it "updates his inviter current_credit by 10.00" do
          expect {
              described_class.add_for_inviter(user, order)
            }.to change(inviter, :current_credit).by(10)
        end

        it "creates a record with invitee_bonus source" do
          described_class.add_for_inviter(user, order)
          inviter.credits.last.source.should == "invitee_bonus"
        end
      end

      context "and user is doing his second buy" do
        before do
          user.stub(:first_buy?).and_return(false)
        end

        it "does not change user current_credit" do
          expect {
              described_class.add_for_inviter(user, order)
            }.to_not change(inviter, :current_credit)
        end

        it "returns false" do
          described_class.add_for_inviter(user, order).should be_false
        end
      end
    end
  end

  describe "removing user credit" do
    context "when the user has not enough credit" do
      it "returns false" do
        described_class.remove(123,user,anything).should be_false
      end
    end

    context "when the user has enough credit" do
      let!(:credit) { FactoryGirl.create(:credit, :total => 100.0, :user => user)}
      let(:order) { FactoryGirl.create(:order_without_payment) }
      let(:amount) { BigDecimal.new("33.33") }

      it "changes user current_credit by the received amount" do
        expect {
          described_class.remove(amount, user, order)
        }.to change(user, :current_credit).by(-amount)
      end

      describe "credit record value" do
        before do
          described_class.remove(amount, user, order)
        end

        it "has its value equal to the spent value" do
          described_class.last.value = amount
        end

        it "has its order equal to the received order" do
          described_class.last.order.should == order
        end

        it "has its source equal to order" do
          described_class.last.source.should == "order_debit"
        end

      end

    end
  end

  describe "adding user credit" do

    let!(:credit) { FactoryGirl.create(:credit, :total => 100.0, :user => user)}
    let(:order) { FactoryGirl.create(:order_without_payment) }
    let(:amount) { BigDecimal.new("33.33") }

    it "increases user current_credit by the received amount" do
      expect {
        described_class.add(amount, user, order)
      }.to change(user, :current_credit).by(amount)
    end

    describe "credit record value" do
      before do
        described_class.add(amount, user, order)
      end

      it "has its value equal to the spent value" do
        described_class.last.value = amount
      end

      it "has its order equal to the received order" do
        described_class.last.order.should == order
      end

      it "has its source equal to order" do
        described_class.last.source.should == "order_credit"
      end
    end
  end


end