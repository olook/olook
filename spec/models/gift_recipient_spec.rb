# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GiftRecipient do

  subject do
    FactoryGirl.create(:gift_recipient)
  end

  let!(:profile_one) { FactoryGirl.create(:casual_profile) }
  let!(:profile_two) { FactoryGirl.create(:sporty_profile) }

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

    it { should have_many :gift_occasions }

    describe "name" do
      it { should validate_presence_of :name }
      it { should allow_value("Jane doe").for(:name) }
      it { should_not allow_value("A").for(:name) }
      it { should_not allow_value("  ").for(:name) }
      it { should_not allow_value("José Francisco Xavier de Paula Domingos António Agostinho Anastácio de Bragança").for(:name) }
    end

    describe "shoe size" do
      it { should allow_value(35).for(:shoe_size) }
      it { should_not allow_value(0).for(:shoe_size) }
      it { should_not allow_value(-1).for(:shoe_size) }
      it { should_not allow_value("aa").for(:shoe_size) }
    end

    context "shoe size conditional validation" do
      context "when the gift recipient has no profile_id" do
        it "does not validates the presence of shoe size" do
          subject.update_attributes(:profile_id => nil, :shoe_size => nil).should be_true
        end
      end

      context "when the recipient has a profile id" do
        it "validates the presence of shoe size" do
          subject.update_attributes(:profile_id => 3, :shoe_size => nil).should be_false
        end
      end

    end

  end

  describe "#profile_scores" do
    it "returns the profile scores with just one item that responds to #profile method" do
      expected = [Struct.new(:profile).new(subject.ranked_profiles[0]), Struct.new(:profile).new(subject.ranked_profiles[1])]
      subject.profile_scores[0].profile.should == expected[0].profile
      subject.profile_scores[1].profile.should == expected[1].profile
    end
  end

  describe "#update_shoe_size_and_profile_info" do
    it "updates the gift recipient profile_id, shoe_size and ranked profile" do
      params = {:profile_id => "3", :shoe_size => "2"}
      subject.ranked_profile_ids = [1, 2, 3]
      subject.should_receive(:update_attributes).with(:profile_id => "3", :shoe_size => "2", :ranked_profile_ids => [3, 1, 2])
      subject.update_shoe_size_and_profile_info(params)
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
    context "when ranked profile ids list is empty" do
      before do
        subject.ranked_profile_ids = []
        subject.save!
      end

      it "returns all profiles" do
        subject.ranked_profiles.should == [profile_one, profile_two]
      end
    end

    context "when ranked profile_ids list includes ids 4,1,3,2" do
      before do
        subject.ranked_profile_ids = [profile_two.id, profile_one.id]
        subject.save!
      end

      it "finds the profiles with these ids" do
        subject.ranked_profiles.should == [profile_two, profile_one]
      end

      context "when first_profile is equal to the profile one" do
        it "returns the profiles with the profile one as the first result" do
          subject.ranked_profiles(profile_one.id.to_s).should == [profile_one, profile_two]
        end
      end

      context "when first_profile is equal to the profile two" do
        it "finds the profiles with the profile two as the first result" do
          subject.ranked_profiles(profile_two.id.to_s).should == [profile_two, profile_one]
        end
      end
    end
  end
end
