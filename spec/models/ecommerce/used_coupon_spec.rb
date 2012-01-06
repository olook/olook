# -*- encoding : utf-8 -*-
require "spec_helper"

describe UsedCoupon do
  it { should belong_to(:order) }
  it { should belong_to(:coupon) }
end
