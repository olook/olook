require 'spec_helper'

describe Point do
  before do
    @user = mock_model('User')
    @profile = mock_model('Profile')
  end

  it "should create a point" do
    Point.create!(:value => 10, :user_id => @user.id, :profile_id => @profile.id)
  end

end
