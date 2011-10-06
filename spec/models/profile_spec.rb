require 'spec_helper'

describe Profile do

  it "should create a profile" do
    Profile.create(:name => "Foo Profile")
  end

end
