# -*- encoding : utf-8 -*-
require "spec_helper"

describe BilletExpirationDate do
  it "should return next tuesday if today is saturday" do
    Date.stub(:current).and_return Date.civil(2012, 01, 14)
    BilletExpirationDate.expiration_for_two_business_day.should == Date.civil(2012, 01,17)
  end

  it "should return next tuesday if today is sunday" do
    Date.stub(:current).and_return Date.civil(2012, 01, 15)
    BilletExpirationDate.expiration_for_two_business_day.should == Date.civil(2012, 01,17)
  end

  it "should return next wednesday if today is monday" do
    Date.stub(:current).and_return Date.civil(2012, 01, 16)
    BilletExpirationDate.expiration_for_two_business_day.should == Date.civil(2012, 01,18)
  end

  it "should return next thursday if today is tuesday" do
    Date.stub(:current).and_return Date.civil(2012, 01,17)
    BilletExpirationDate.expiration_for_two_business_day.should == Date.civil(2012, 01,19)
  end

  it "should return next friday if today is wednesday" do
    Date.stub(:current).and_return Date.civil(2012, 01,18)
    BilletExpirationDate.expiration_for_two_business_day.should == Date.civil(2012, 01,20)
  end

  it "should return next monday if today is thursday" do
    Date.stub(:current).and_return Date.civil(2012, 01,19)
    BilletExpirationDate.expiration_for_two_business_day.should == Date.civil(2012, 01, 23)
  end
end
