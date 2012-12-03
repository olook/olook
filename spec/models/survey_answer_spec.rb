# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SurveyAnswer do
  it "should create a SurveyAnswer" do
  	user = FactoryGirl.create(:user)
    SurveyAnswer.create!(:user => user, :answers => {:foo => :bar})
  end
end
