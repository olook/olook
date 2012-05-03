require 'spec_helper'

describe UserLiquidationsController do
  with_a_logged_user do
    it "should update the dont_want_to_see_again field" do
      FactoryGirl.create(:liquidation)
      expect {
        post :update, :user_liquidation => {:dont_want_to_see_again => true}
      }.to change(UserLiquidation, :count).by(1)
      UserLiquidation.last.dont_want_to_see_again.should be_true
    end
  end

end
