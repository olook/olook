# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Credit do
  it { should belong_to(:user_credit) }
  it { should belong_to(:order) }
  it { should validate_presence_of(:value) }

  context "description format validation for loyalty credits" do

    let(:credit) { FactoryGirl.create(:credit)}
    let(:order) {FactoryGirl.create(:order)}

    let(:order_date) { Time.new(2012, 9, 10, 4) }
    let(:activates_at)  {Time.new(2012, 10, 1, 3)}
    let(:expires_at) { Time.new(2012, 11, 30, 2)}

    it "shouldn't print the order data when order is nil" do
      credit.stub(:activates_at).and_return(activates_at)
      credit.stub(:expires_at).and_return(expires_at)
      
      description = credit.description_for(:loyalty)
      description.should == "Crédito disponível de 01/10/2012 a 30/11/2012"

    end


    it "should print the order data when order isnt nil" do

      order.stub(:created_at).and_return(order_date)
      credit.stub(:activates_at).and_return(activates_at)
      credit.stub(:expires_at).and_return(expires_at)

      credit.order = order
      
      description = credit.description_for(:loyalty)
      description.should == "Compra realizada em 10/09/2012. Crédito disponível de 01/10/2012 a 30/11/2012"
    end

  end
end