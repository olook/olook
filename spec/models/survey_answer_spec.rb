# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SurveyAnswer do
  it "should create a SurveyAnswer" do
  	user = Factory(:user)
    SurveyAnswer.create!(:user => user, :answers => {:foo => :bar})
  end
end
