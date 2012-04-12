# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GiftRecipient do
  
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

  describe ".update_profile_and_shoe_size" do
    context "when gift_recipient is nil" do
      it "returns nil" do
        described_class.update_profile_and_shoe_size(nil,anything).should be_nil
      end
    end

    context "when no gift_recipient with the received id is found" do
      it "returns nil" do
        described_class.update_profile_and_shoe_size(1,anything).should be_nil
      end
    end

    context "when gift_recipient exists" do
      let!(:gift_recipient) { FactoryGirl.create(:gift_recipient) }
      let!(:profile) { FactoryGirl.create(:casual_profile) }
      let!(:shoe_size) { 39 }

      context "and the profile is received" do
        it "updates the gift recipient profile" do
          described_class.update_profile_and_shoe_size(gift_recipient.id, profile)
          gift_recipient.reload
          gift_recipient.profile.should == profile
        end

        it "returns the gift recipient" do
          described_class.update_profile_and_shoe_size(gift_recipient.id,profile).should == gift_recipient
        end
      end

      context "and the profile and shoe size are received" do
        it "updates the gift recipient profile and shoe size" do
          described_class.update_profile_and_shoe_size(gift_recipient.id, profile, shoe_size)
          gift_recipient.reload
          gift_recipient.profile.should == profile
          shoe_size.should == shoe_size
        end

        it "returns the gift recipient" do
          described_class.update_profile_and_shoe_size(gift_recipient.id, profile, shoe_size).should == gift_recipient
        end

        context "when shoe size in nil" do
          it "does not updates shoe size" do
            described_class.update_profile_and_shoe_size(gift_recipient.id, profile, nil)
            gift_recipient.reload
            shoe_size.should_not be_nil
            gift_recipient.profile.should == profile
          end
        end
      end
    end
  end

end
