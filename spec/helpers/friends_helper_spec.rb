require 'spec_helper'

describe FriendsHelper do
  it "should return the question title for a friend" do
    user_name = "User name"
    question_title = "Qual sapato combina mais com __USER_NAME__?"
    expected = "Qual sapato combina mais com <span>#{user_name}</span>?"
    helper.question_title_for_friend(question_title, user_name).should == expected
  end
end
