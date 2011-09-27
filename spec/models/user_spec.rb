require 'spec_helper'

describe User do
  before(:all) do
    @user = User.create!(:first_name => "John",
                 :last_name => "Doe",
                 :email => "johndoe@foobar.com",
                 :password => "123456")
  end

  before do
    @profile = mock_model('Profile')
  end

  it "should counts and write points" do
    hash = {@profile.id => 2}
    @user.counts_and_write_points(hash)
    Point.should have(1).record
  end

end
