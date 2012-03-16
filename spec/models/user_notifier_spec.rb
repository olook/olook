# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserNotifier do

  describe ".get_orders" do
    it "should get the validators params to get orders" do
      validators = UserNotifier.get_orders( "in_the_cart", 0, 1, [ "in_cart_notified = 0" ] )
      validators.should_not == []
    end
  end

  describe ".send_in_cart" do
  let(:user) { FactoryGirl.create :user }
  let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  subject { FactoryGirl.create(:clean_order, :user => user)}
  let(:mailer) { double(:mailer)}

    before do
      subject.add_variant(basic_shoe_35)
      subject.update_attribute( "updated_at", Time.now - 24 * 60 * 60 )
      subject.save!
    end

    it "should send the order email" do
      validators = UserNotifier.get_orders( "in_the_cart", 0, 1, [ "in_cart_notified = 0" ] )
      InCartMailer.should_receive(:send_in_cart_mail).with(subject, subject.line_items).and_return(mailer)
      mailer.should_receive(:deliver)
      UserNotifier.send_in_cart( validators.join(" AND ") )
    end
  end

  describe ".delete_old_orders" do
  let(:user) { FactoryGirl.create :user }
  let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  subject { FactoryGirl.create(:clean_order, :user => user)}

    before :each do
      subject.add_variant(basic_shoe_35)
      subject.update_attribute( "updated_at", Time.now - 24 * 60 * 60 )
      subject.save!
      validators = UserNotifier.get_orders( "in_the_cart", 0, 1 )
      UserNotifier.delete_old_orders( validators.join(" AND ") )
    end

    it "the order should be disabled" do
      Order.find(subject.id).disable.should == true
    end

  end
end