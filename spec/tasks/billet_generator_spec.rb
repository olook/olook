# -*- encoding : utf-8 -*-
require "spec_helper"

describe BilletGenerator do
  it "should generate new billets" do
    response = double
    response.stub(:status).and_return(Payment::SUCCESSFUL_STATUS)
    payment_builder = double
    payment_builder.stub(:process!).and_return(response)
    PaymentBuilder.should_receive(:new).at_least(2).times.and_return(payment_builder)
    user = FactoryGirl.create(:user)
    order = FactoryGirl.create(:order, :user => user)
    billet_1 = FactoryGirl.create(:billet, :order => order)
    billet_2 = FactoryGirl.create(:billet, :order => order)
    billet_1.update_attributes(:payment_expiration_date => nil)
    billet_2.update_attributes(:payment_expiration_date => nil)
    billet_generator = BilletGenerator.new([billet_1, billet_2])
    billet_generator.generate.should == 2
  end
end
