require 'spec_helper'

describe FriendsController do
  with_a_logged_user do
    render_views
    let(:message) { "my message" }

    context "on success" do
      before :each do
        FacebookAdapter.stub(:new).with(user.facebook_token).and_return(@fb_adapter = mock)
      end

      it "should post a message in the facebook wall" do
        @fb_adapter.should_receive(:post_wall_message).with(message).and_return(true)
        post :post_wall, :message => message
      end

      it "should return a success response" do
        @fb_adapter.should_receive(:post_wall_message).with(message).and_return(true)
        post :post_wall, :message => message
        response.should be_success
      end
    end

   context "on failure" do
     it "should return a failure response" do
       FacebookAdapter.stub(:new).with(user.facebook_token).and_return(fb_adapter = mock)
       fb_adapter.should_receive(:post_wall_message).with(message).and_return(false)
       post :post_wall, :message => message
       response.should_not be_success
     end
   end
  end
end
