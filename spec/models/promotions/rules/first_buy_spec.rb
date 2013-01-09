# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FirstBuy do

  describe "#matches?" do
    let(:user) { FactoryGirl.create(:user) }

    it { should respond_to(:matches?).with(1).argument }

    context "should match" do

      it "user discount isn't expired" do
        subject.matches?(user).should be_true
      end

      it "user has no orders" do
        subject.matches?(user).should be_true
      end

    end

    context "should not match" do
      let(:order) {FactoryGirl.create(:clean_order)}

      it "user wasn't informed" do
        subject.matches?(nil).should be_false
      end

      it "user's dicount is expired" do
        user.created_at = user.created_at - 10.days
        subject.matches?(user).should be_false
      end

      it "user has an order" do
        user.orders << order
        subject.matches?(user).should be_false
      end

      it "user has more than one order" do
        user.orders << FactoryGirl.create(:clean_order)
        user.orders << FactoryGirl.create(:clean_order)

        subject.matches?(user).should be_false
      end
    end

  end
end
