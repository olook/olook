# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Credit do
  xit { should belong_to(:user) }
  xit { should belong_to(:order) }
  xit { should validate_presence_of(:value) }

  let(:user) { FactoryGirl.create(:member) }
  let(:invite) { FactoryGirl.create(:invite, :user => user ) }

  describe "adding bonus for a inviter after invitee completes an order" do
    let(:inviter) { FactoryGirl.create(:member) }
    let(:order) {FactoryGirl.create(:order, :user => user)}

    context "when the user is not invited" do
      before do
        user.update_attribute(:is_invited,false)
      end

      xit "does not change user current_credxit" do
        expect {
          described_class.add_for_inviter(user, order)
        }.to_not change(inviter, :current_credit)
      end

      xit "returns false" do
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

        xit "updates his inviter current_credit by 10.00" do
          expect {
              described_class.add_for_inviter(user, order)
            }.to change(inviter, :current_credit).by(10)
        end

        xit "creates a record with invitee_bonus source" do
          described_class.add_for_inviter(user, order)
          inviter.credits.last.source.should == "invitee_bonus"
        end
      end

      context "and user is doing his second buy" do
        before do
          user.stub(:first_buy?).and_return(false)
        end

        xit "does not change user current_credit" do
          expect {
              described_class.add_for_inviter(user, order)
            }.to_not change(inviter, :current_credit)
        end

        xit "returns false" do
          described_class.add_for_inviter(user, order).should be_false
        end
      end

    end
  end

  describe "removing user credit" do
    context "when the user has not enough credit" do
      xit "returns false" do
        described_class.remove(123,user,anything).should be_false
      end
    end

    context "when the user has enough credit" do
      let!(:credit) { FactoryGirl.create(:credit, :total => 100.0, :user => user)}
      let(:order) { FactoryGirl.create(:clean_order) }
      let(:amount) { BigDecimal.new("33.33") }

      xit "changes user current_credit by the received amount" do
        expect {
          described_class.remove(amount, user, order)
        }.to change(user, :current_credit).by(-amount)
      end

      describe "credit record value" do
        before do
          described_class.remove(amount, user, order)
        end

        xit "has its value equal to the spent value" do
          described_class.last.value = amount
        end

        xit "has its order equal to the received order" do
          described_class.last.order.should == order
        end

        xit "has its source equal to order" do
          described_class.last.source.should == "order_debit"
        end

      end

    end
  end

  describe "adding user credit" do

    let!(:credit) { FactoryGirl.create(:credit, :total => 100.0, :user => user)}
    let(:order) { FactoryGirl.create(:clean_order) }
    let(:amount) { BigDecimal.new("33.33") }
    let(:high_amount) { BigDecimal.new(100_000.to_s) }

    xit "increases user current_credit by the received amount" do
      expect {
        described_class.add(amount, user, order)
      }.to change(user, :current_credit).by(amount)
    end

    xit "is limitless" do
        expect {
          described_class.add(high_amount, user, order)
        }.to_not change(user, :current_credit).by(amount)
    end

    describe "credit record value" do
      before do
        described_class.add(amount, user, order)
      end

      xit "has its value equal to the spent value" do
        described_class.last.value = amount
      end

      xit "has its order equal to the received order" do
        described_class.last.order.should == order
      end

      xit "has its source equal to order" do
        described_class.last.source.should == "order_credit"
      end
    end

    context "when user recieve" do      
    end
  end

end