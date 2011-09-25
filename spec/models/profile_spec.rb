require 'spec_helper'

describe Profile do
  it "should add a profile" do
    Profile.create!(:name => "Foo Profile")
  end

  it "should build an array of profiles given the answers" do
    #casual_profile = Factory(:casual_profile)
    #sporty_profile = Factory(:sporty_profile)
    #debugger
    answer_from_casual_profile = Factory(:answer_from_casual_profile)
    answer_from_sporty_profile = Factory(:answer_from_casual_profile)
    questions = {"question_1"=> answer_from_casual_profile.id,
                 "question_2"=> answer_from_sporty_profile.id }
    expected = [answer_from_casual_profile.profile, answer_from_sporty_profile.profile]             
    Profile.profiles_given_questions(questions).should == expected  
  end             
end
