# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InCartMailer do
  let(:user) { FactoryGirl.create(:user) }
  let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  subject { FactoryGirl.create(:clean_order, :user => user)}

    describe "#send_in_cart_mail" do
    
    before :each do
      subject.add_variant(basic_shoe_35)
    end

    let!(:mail) { InCartMailer.send_in_cart_mail(subject, subject.line_items) }

    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      mail.from.should include("avisos@olook.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(user.email)
    end

    it "sets 'subject' attribute to inform there are products without checkout" do
      mail.subject.should == "#{user.first_name}, os seus produtos ainda estão disponíveis."
    end

  end

end
