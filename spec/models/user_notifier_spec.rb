# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserNotifier do

  describe ".get_orders" do
    it "Should get the validators params to get orders" do
      validators = UserNotifier.get_orders( "in_the_cart", 0, 1, [ "in_cart_notified = 0" ] )
      validators.should_not == []
    end
  end

  describe ".send_in_cart" do
  let(:user) { FactoryGirl.create :user }
  let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  subject { FactoryGirl.create(:clean_order, :user => user)}

    before :each do
      ActionMailer::Base.deliveries = []
      subject.add_variant(basic_shoe_35)
      subject.update_attribute( "updated_at", Time.now - 24 * 60 * 60 )
      subject.save!
      validators = UserNotifier.get_orders( "in_the_cart", 0, 1, [ "in_cart_notified = 0" ] )
      UserNotifier.send_in_cart( validators.join(" AND ") )
    end

    it "Should send the order email" do
      ActionMailer::Base.deliveries.should_not == []
    end

    it "The email should be related to the user" do
      ActionMailer::Base.deliveries[0].to[0].should == user.email
    end

    it "The user authentication token should be reseted" do
      User.find(user.id).authentication_token.should_not == nil
    end

  end

  describe ".delete_old_orders" do
  let(:user) { FactoryGirl.create :user }
  let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  subject { FactoryGirl.create(:clean_order, :user => user)}

    before :each do
      ActionMailer::Base.deliveries = []
      subject.add_variant(basic_shoe_35)
      subject.update_attribute( "updated_at", Time.now - 24 * 60 * 60 )
      subject.save!
      validators = UserNotifier.get_orders( "in_the_cart", 0, 1 )
      UserNotifier.delete_old_orders( validators.join(" AND ") )
    end

    it "Thr order should be disabled" do
      Order.find(subject.id).disable.should == true
    end

  end
end