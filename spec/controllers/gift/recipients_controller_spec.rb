# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Gift::RecipientsController do
  let!(:recipient) { FactoryGirl.create(:gift_recipient) }
  let!(:id) { recipient.id.to_s }
  let!(:first_profile) { FactoryGirl.create(:casual_profile) }
  let!(:second_profile) { FactoryGirl.create(:sporty_profile) }
  let(:profiles) { [first_profile, second_profile] }
  let!(:profile_ids) { [first_profile.id, second_profile.id] }

  describe "GET 'edit'" do

    it "load and assigns @gift_recipient" do
      GiftRecipient.should_receive(:find).with(id)
      post 'edit', :id => id
    end

    it "assigns gift recipient to @gift_recipint" do
      GiftRecipient.stub(:find).and_return(recipient)
      post 'edit', :id => id
      assigns(:gift_recipient).should == recipient
    end

    context "when no profile_id list is found in the session" do
      it "gets all profiles" do
        Profile.should_receive(:all).and_return(profiles)
        get 'edit', :id => id
      end
    end

    context "when a profile_id list is found in the session" do

      before do
        session[:recipient_profiles] = profile_ids
      end

      it "finds the profiles in the session and assigns @profiles" do
        Profile.should_receive(:find).with(*profile_ids).and_return(profiles)
        get 'edit', :id => id
        assigns(:profiles).should == profiles
      end

      context "when the gift_recipient has no profile assigned" do
        before do
          GiftRecipient.any_instance.stub(:profile).and_return(nil)
        end

        it "updates the gift_recipient profile attribute with the first profile" do
          GiftRecipient.any_instance.should_receive(:update_attributes!).with(:profile => first_profile)
          get 'edit', :id => id
        end
      end

      context "when the user already has a profile" do
        before do
          GiftRecipient.any_instance.stub(:profile).and_return(anything)
        end
        it "does not update the gift_recipient profile" do
          Profile.stub(:find).and_return(profiles)
          GiftRecipient.any_instance.should_not_receive(:update_attributes!)
          get 'edit', :id => id
        end
      end
    end
  end

  describe "POST 'update'" do

    let(:params) { {:gift_recipient => {} } }

    it "load and assigns @gift_recipient" do
      GiftRecipient.should_receive(:find).with(id)
      post 'update', :id => id
    end

    it "assigns gift recipient to @gift_recipint" do
      GiftRecipient.stub(:find).and_return(recipient)
      post 'update', :id => id
      assigns(:gift_recipient).should == recipient
    end

    it "redirects to gift suggestions path" do
      post 'update', :id => id, :gift_recipient => { :shoe_size => "39"}
      response.should redirect_to gift_suggestions_path
    end

    context "when the gift recipient belongs to the current user" do
      before do
        sign_in recipient.user
        request.env['devise.mapping'] = Devise.mappings[:user]
        GiftRecipient.any_instance.stub(:belongs_to_user?).with(recipient.user).and_return(true)
      end

      it "updates gift recipient shoe size and profile id only" do
        GiftRecipient.any_instance.should_receive(:update_attributes!).with("shoe_size" => "39", "profile_id" => "9")
        post 'update', :id => id, :gift_recipient => { :shoe_size => "39", :profile_id => "9", :user_id => "47"}
      end
    end

    context "when the gift recipient does not belong to the user" do
      before do
        sign_in recipient.user
        request.env['devise.mapping'] = Devise.mappings[:user]
        GiftRecipient.any_instance.stub(:belongs_to_user?).with(recipient.user).and_return(false)
      end

      it "updates gift recipient shoe size and profile id only" do
        GiftRecipient.any_instance.should_not_receive(:update_attributes!)
        post 'update', :id => id, :gift_recipient => { :shoe_size => "39", :profile_id => "9", :user_id => "47"}
      end
    end

    context "when no shoe size is selected" do
      it "redirects to edit recipient and shows message" do
        post 'update', :id => id, :gift_recipient => { :shoe_size => nil }
        response.should redirect_to edit_gift_recipient_path(recipient)
        flash[:notice].should == "Por favor, escolha o número de sapato da sua presenteada."
      end
    end

  end

end
