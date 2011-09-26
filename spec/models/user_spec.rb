require 'spec_helper'

describe User do
  it "should create an user" do
    User.create!(:first_name => "John",
                 :last_name => "Doe",
                 :email => "johndoe@foobar.com",
                 :password => "123456")
  end

end
