require 'spec_helper'

describe UserProfile do
  before do
    @user = mock_model('User')
    @profile = mock_model('Profile')
  end

  it "should create a user profile" do
    UserProfile.create!(:user_id => @user.id, :profile_id => @profile.id)
  end

end
