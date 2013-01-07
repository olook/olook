# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FirstBuy do

  describe "#matches?" do

    it { should respond_to(:matches?).with(1).argument }

    context "user was not informed" do
      it "should not match" do
        subject.matches?({}).should be_false
      end
    end
    
    context "user has no orders" do
      let(:user) {FactoryGirl.create(:user)}
      
      it "should match" do
        subject.matches?({user: user}).should be_true
      end
    end

    context "user has an order" do
      let(:user) {FactoryGirl.create(:user)}
      let(:order) {FactoryGirl.create(:clean_order)}

      before do
        user.orders << order
      end

      it "should not match" do
        subject.matches?({user: user}).should be_false
      end
    end

    context "user has more than one order" do
      let(:user) {FactoryGirl.create(:user)}

      before do
        user.orders << FactoryGirl.create(:clean_order)
        user.orders << FactoryGirl.create(:clean_order)
      end        

      it "should not match" do
        subject.matches?({user: user}).should be_false
      end

    end


  end
end