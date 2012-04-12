require 'spec_helper'

describe Gift::RecipientsController do

  describe "GET 'new'" do
    let(:profiles) { double(:profiles, :first => 'first') }

    context "when no profile_id list is found in the session" do
      it "redirect to gift home path" do
        get 'new'
        response.should redirect_to gift_root_path
      end
    end

    context "when a profile_id list is found in the session" do
      let(:profile_ids) { [1,2,3] }

      before do
        session[:recipient_profiles] = profile_ids
        session[:recipient_id] = 5
      end

      it "finds the profiles in the session and assigns @profiles" do
        GiftRecipient.stub(:update_profile_and_shoe_size)
        Profile.should_receive(:find).with(1,2,3).and_return(profiles)
        get 'new'
        assigns(:profiles).should == profiles
      end

      it "updates the gift_recipient found in the session and assigns @gift_recipient" do
        gift_recipient = double(:gift_recipient)
        Profile.stub(:find).and_return(profiles)
        GiftRecipient.should_receive(:update_profile_and_shoe_size).with(5,"first").and_return(gift_recipient)
        get 'new'
        assigns(:gift_recipient).should == gift_recipient
      end

    end
  end

  describe "POST 'create'" do
    it "redirects_to gift_root_path" do
      post 'create'
      response.should redirect_to gift_root_path
    end
  end

  describe "POST 'update'" do
    it "returns http success" do
      post 'update'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

end
