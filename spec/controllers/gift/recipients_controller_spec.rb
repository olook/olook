# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Gift::RecipientsController do
  let!(:recipient) { FactoryGirl.create(:gift_recipient) }
  let!(:id) { recipient.id.to_s }
  let!(:first_profile) { FactoryGirl.create(:casual_profile) }
  let!(:second_profile) { FactoryGirl.create(:sporty_profile) }
  let(:profiles) { [first_profile, second_profile] }

  describe "GET 'edit'" do

    it "load and assigns @gift_recipient" do
      GiftRecipient.should_receive(:find).with(id).and_return(recipient)
      get 'edit', :id => id
    end

    it "assigns gift recipient to @gift_recipint" do
      GiftRecipient.stub(:find).and_return(recipient)
      get 'edit', :id => id
      assigns(:gift_recipient).should == recipient
    end

    context "when a gift recipient is found" do
      before do
        GiftRecipient.stub(:find).and_return(recipient)
      end

      context "and profile_id param is not present" do
        it "gets all ranked profile ids from gift_recipient" do
          GiftRecipient.any_instance.should_receive(:ranked_profiles).with(nil).and_return(profiles)
          get 'edit', :id => id
        end
      end

      context "and profile_id param is present" do
        it "gets all ranked profile ids from gift_recipient passing profile_id" do
          GiftRecipient.any_instance.should_receive(:ranked_profiles).with("3").and_return(profiles)
          get 'edit', :id => id, :gift_recipient => { :profile_id => "3" }
        end
      end

    end
  end

  describe "POST 'update'" do

    let(:params) { {:gift_recipient => {} } }

    it "finds @gift_recipient" do
      GiftRecipient.should_receive(:find).with(id).and_return(recipient)
      post 'update', :id => id
    end

    it "assigns gift recipient to @gift_recipint" do
      GiftRecipient.stub(:find).and_return(recipient)
      post 'update', :id => id
      assigns(:gift_recipient).should == recipient
    end

    it "redirects to gift suggestions path" do
      post 'update', :id => id, :gift_recipient => { :shoe_size => "39"}
      response.should redirect_to gift_recipient_suggestions_path(recipient)
    end
      
    it "updates gift recipient shoe size and profile id only" do
      GiftRecipient.any_instance.should_receive(:update_attributes).with("shoe_size" => "39", "profile_id" => "9")
      post 'update', :id => id, :gift_recipient => { :shoe_size => "39", :profile_id => "9", :user_id => "47"}
    end

    context "when no shoe size is selected" do
      it "redirects to edit recipient and shows message" do
        post 'update', :id => id, :gift_recipient => { :profile_id => "9", :shoe_size => nil }
        response.should redirect_to edit_gift_recipient_path(recipient)
        flash[:notice].should == "Por favor, escolha o número de sapato da sua presenteada."
      end
    end

  end

end
