# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserNotifier do

  describe ".get_carts" do
    it "should get the validators params to get orders" do
      validators = UserNotifier.get_carts( 0, 1, [ "notified = 0" ] )
      validators.should_not == []
    end

    it 'should not return carts without users' do
      FactoryGirl.create(:clean_cart)
      conditions = UserNotifier.get_carts( 0, 1, [ "notified = 0" ] )
      Cart.where(conditions.join(" AND ")).count.should == 0
    end
  end

  describe ".send_in_cart" do
    let(:user) { FactoryGirl.create :user }
    let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
    let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
    subject { FactoryGirl.create(:clean_cart, :user => user)}
    let(:mailer) { double(:mailer)}

    before do
      subject.add_variant(basic_shoe_35)
      subject.update_attribute( "updated_at", Time.now - 24 * 60 * 60 )
      subject.save!
    end

    it "should send the order email" do
      validators = UserNotifier.get_carts( 0, 1, [ "notified = 0" ] )
      InCartMailer.should_receive(:send_in_cart_mail).with(subject, subject.items).and_return(mailer)
      mailer.should_receive(:deliver)
      UserNotifier.send_in_cart( validators.join(" AND ") )
    end
  end
end
