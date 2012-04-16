# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GiftRecipient do
  
  it "should return the first name" do
    gift_recipient = FactoryGirl.create(:gift_recipient, :name => "John Travolta")
    gift_recipient.first_name.should == "John"
    gift_recipient.name = "Fry"
    gift_recipient.first_name.should == "Fry"  
    gift_recipient.name = ""
    gift_recipient.first_name.should be_nil    
  end
  
  context "validation" do
    # it { should validate_presence_of :user }
    it { should belong_to :user }
    
    # it { should validate_presence_of :gift_recipient_relation }
    it { should belong_to :gift_recipient_relation }

    it { should belong_to :profile }

    describe "name" do
      it { should validate_presence_of :name }
      it { should allow_value("Jane doe").for(:name) }
      it { should_not allow_value("A").for(:name) }
      it { should_not allow_value("  ").for(:name) }
    end
    
    describe "shoe size" do
      # it { should validate_presence_of :shoe_size }
      it { should allow_value(35).for(:shoe_size) }
      it { should_not allow_value(0).for(:shoe_size) }
      it { should_not allow_value(-1).for(:shoe_size) }
      it { should_not allow_value("aa").for(:shoe_size) }
    end
  end
end
