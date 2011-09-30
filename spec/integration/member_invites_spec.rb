require 'spec_helper'
require 'integration/helpers'

feature "Member can send invites", %q{
  In order to show my showroom for my girlfriends
  As a member
  I want to invite people to join the site
} do

  background do
    @member = FactoryGirl.create(:member)
    User.any_instance.stub(:counts_and_write_points)
    @answer = FactoryGirl.create(:answer_from_casual_profile)
    @question = @answer.question
    answer_survey(@question)
  end

  describe "On the invite page, a member can invite people by" do 
    scenario "copying and pasting a link" do 
    end

    scenario "tweeting the link" do
    end

    scenario "posting the link on her Facebook wall" do
    end
  end
end
