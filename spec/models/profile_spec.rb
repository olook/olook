require 'spec_helper'

describe Profile do
  it "should add a profile" do
    Profile.create!(:name => "Foo Profile")
  end
end
