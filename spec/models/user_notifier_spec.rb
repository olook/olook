# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserNotifier do
  describe ".get_orders" do
    let(:order) { FactoryGirl.create(:order) }

    it "Should get the same order according of the parameters" do
      order.update_attribute( "updated_at", Time.now - 24 * 60 * 60 )
      order.save!
      orders = UserNotifier.get_orders( "in_the_cart", 0, 1, [ "in_cart_notified = 0" ] )
      orders[0].should == order
    end

  end
end