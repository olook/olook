# == Schema Information
#
# Table name: promotions
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  description      :string(255)
#  strategy         :string(255)
#  priority         :integer
#  discount_percent :integer
#  active           :boolean
#  created_at       :datetime
#  updated_at       :datetime
#  param            :string(255)
#  my_order_label   :string(255)
#  cart_label       :string(255)
#  banner_label     :string(255)
#

require 'spec_helper'

describe Promotion do
  describe "strategies" do
    it "should apply the appropriated strategy" do
      promo = FactoryGirl.create(:first_time_buyers)
      promo.load_strategy.to_s.should  == "Promotions::PurchasesAmountStrategy"
    end
  end
end
