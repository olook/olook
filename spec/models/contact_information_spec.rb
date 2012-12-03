require 'spec_helper'

describe ContactInformation do
  it "should create a contact information" do
    ContactInformation.create!(:title => "Lorem ipsum dolor sit amet.", :email => "foo@bar.com")
  end
end
