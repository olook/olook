# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartBuilder do

  xit "should build gift session"

  xit "should build offline session" do
    session[:order] = order.id
    session[:offline_variant] = { "id" => variant.id }
    session[:offline_first_access] = true
    get :showroom
    order.line_items.count.should  be_eql(1)
    session[:offline_first_access].should be_nil
    session[:offline_variant].should be_nil
  end
end