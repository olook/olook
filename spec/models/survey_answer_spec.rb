# == Schema Information
#
# Table name: survey_answers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  answers    :text
#  created_at :datetime
#  updated_at :datetime
#

# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SurveyAnswer do
  it "should create a SurveyAnswer" do
  	user = FactoryGirl.create(:user)
    SurveyAnswer.create!(:user => user, :answers => {:foo => :bar})
  end
end
