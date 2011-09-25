require 'spec_helper'

describe Profile do

  let(:answer_from_casual_profile) { Factory(:answer_from_casual_profile) }
  let(:answer_from_sporty_profile) { Factory(:answer_from_sporty_profile) }

  let(:profiles) {[answer_from_casual_profile.profile, 
	                answer_from_sporty_profile.profile,
	                answer_from_casual_profile.profile]}

  it "should add a profile" do
    Profile.create!(:name => "Foo Profile")
  end

  it "should build an array of profiles given the answers" do
    questions = {"question_1"=> answer_from_casual_profile.id,
                 "question_2"=> answer_from_sporty_profile.id }
    expected = [answer_from_casual_profile.profile, answer_from_sporty_profile.profile]             
    Profile.profiles_given_questions(questions).should == expected  
  end  
  
  it "should build an array of profiles given the answers" do 
	expected = {answer_from_casual_profile.profile.id => 2,
		        answer_from_sporty_profile.profile.id => 1}                        
    Profile.build_profiles_points(profiles).should == expected
  end             
end
