# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FirstBuy do

  describe "#matches?" do
    let(:user) { FactoryGirl.create(:user) }
    let(:cart) { mock_model Cart, user: user }

    it { should respond_to(:matches?).with(1).argument }

    context "when user has no authorized orders" do
      it "matches" do
        subject.matches?(cart).should be_true
      end
    end

    context "when user's discount isn't expired" do
      it "matches" do
        subject.matches?(cart).should be_true
      end
    end

    context "when user is nil" do
      it "matches" do
        subject.matches?(cart).should be_true
      end
    end

    context "when user has authorized orders" do

      it "doesn't match" do
        user.should_receive(:has_purchased_orders?).and_return(true)
        subject.matches?(cart).should be_false
      end
    end   

  end
end
