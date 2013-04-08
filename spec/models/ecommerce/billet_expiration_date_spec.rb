# -*- encoding : utf-8 -*-
require "spec_helper"

describe BilletExpirationDate do
  it "should return next tuesday if today is saturday" do
    Timecop.freeze(Date.civil(2012, 01, 14)) do
      BilletExpirationDate.expiration_for_two_business_day.should eql Date.civil(2012, 01,17)
    end
  end

  it "should return next tuesday if today is sunday" do
    Timecop.freeze(Date.civil(2012, 01, 15)) do
      BilletExpirationDate.expiration_for_two_business_day.should eql Date.civil(2012, 01,17)
    end
  end

  it "should return next wednesday if today is monday" do
    Timecop.freeze(Date.civil(2012, 01, 16)) do 
      BilletExpirationDate.expiration_for_two_business_day.should eql Date.civil(2012, 01,18)
    end
  end

  it "should return next thursday if today is tuesday" do
    Timecop.freeze(Date.civil(2012, 01, 17)) do
      BilletExpirationDate.expiration_for_two_business_day.should eql Date.civil(2012, 01,19)
    end
  end

  it "should return next friday if today is wednesday" do
    Timecop.freeze(Date.civil(2012, 01, 18)) do 
      BilletExpirationDate.expiration_for_two_business_day.should eql Date.civil(2012, 01,20)
    end
  end

  it "should return next monday if today is thursday" do
    Timecop.freeze(Date.civil(2012, 01, 19)) do
      BilletExpirationDate.expiration_for_two_business_day.should eql Date.civil(2012, 01, 23)
    end
  end
end
