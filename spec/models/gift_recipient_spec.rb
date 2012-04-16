# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GiftRecipient do
  subject do
    FactoryGirl.create(:gift_recipient)
  end
  
  it "should return the first name" do
    gift_recipient = FactoryGirl.create(:gift_recipient, :name => "John Travolta")
    gift_recipient.first_name.should == "John"
    gift_recipient.name = "Fry"
    gift_recipient.first_name.should == "Fry"
    gift_recipient.name = ""
    gift_recipient.first_name.should be_nil
  end

  context "validations" do
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

  describe "#belongs_to_user?" do
    context "when no user is passed" do
      it "returns nil" do
        subject.belongs_to_user?(nil).should be_false
      end
    end

    context "when the gift recipient user_id matches with the user id" do
      it "returns true" do
        subject.belongs_to_user?(subject.user).should be_true
      end
    end

    context "when the gift_recipient user_id does not match with the user id" do
      it "returns false" do
        user = double(:id => 1234)
        subject.belongs_to_user?(user).should be_false
      end
    end

    context "when the gift_recipient user_id is nil and the user passed is nil" do
      before do
        subject.user_id = nil
        subject.save!
      end

      it "returns true" do
        subject.belongs_to_user?(nil).should be_true
      end
    end
  end

  context "#ranked_profiles" do
    let(:profiles) { double(:profiles) }

    context "when ranked profile ids list is empty" do
      before do
        subject.ranked_profile_ids = nil
        subject.save!
      end

      it "returns nil" do
        subject.ranked_profiles.should be_nil
      end
    end

    context "when ranked profile_ids list includes ids 4,1,3,2" do
      before do
        subject.ranked_profile_ids = [4,1,3,2]
        subject.save!
      end

      it "finds the profiles with these ids" do
        Profile.should_receive(:find).with(4,1,3,2).and_return(profiles)
        subject.ranked_profiles.should == profiles
      end

      context "when first_profile is passed" do
        it "finds the profiles with the first_profile as the first" do
          Profile.should_receive(:find).with(3,4,1,2).and_return(profiles)
          subject.ranked_profiles(3).should == profiles
        end
      end
    end

  end

end
