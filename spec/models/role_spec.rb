# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Role do

  let(:sac_operator) { Factory(:sac_operator) }

  it "should associate permissions with valid params" do
    pending
  end

  it "should check if it has permissions associated" do
    sac_operator.has_permission?(sac_operator.permissions[0].id).should eq(true)
  end


  
end
