require 'spec_helper'

describe Gift::SuggestionsController do
  
  let!(:recipient) { FactoryGirl.create(:gift_recipient) }
  let!(:occasion) { FactoryGirl.create(:gift_occasion) }
  
  describe "GET 'index'" do
    before do
      session[:occasion_id] = occasion.id
    end
    
    context "gift_recipient" do
      it "finds gift recipient" do
        GiftRecipient.should_receive(:find).with("123").and_return(recipient)
        get 'index', :recipient_id => "123"
      end

      it "assigns @gift_recipient to the recipient found" do
        get 'index', :recipient_id => recipient.id.to_s
        assigns(:gift_recipient).should == recipient
      end
    end
    
    context "occasion" do
      it "finds the occasion from the session" do
        session[:occasion_id] = "456"
        GiftOccasion.should_receive(:find).with("456").and_return(occasion)
        get 'index', :recipient_id => recipient.id
      end
      
      it "assigns @occasion to the found occasion" do
        GiftOccasion.stub(:find).and_return(occasion)
        get 'index', :recipient_id => recipient.id
        assigns(:occasion).should == occasion
      end
    end

  end

end
