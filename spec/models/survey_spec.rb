# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Survey do
  before :each do
    @survey_data = []
    @survey_data[0] = {
      :question_title => "Question one",
      :answers => (1..3).to_a,
      :weights => [{ 1 => {"10" => "Casual", "5" => "Contemporânea"}},
                   { 2 => {"5" => "Contemporânea", "10" => "Casual"}}]
    }

    @survey_data[1] = {
      :question_title => "Question two",
      :answers => (1..5).to_a,
      :weights => []
    }

    @survey = Survey.new(@survey_data)
  end

  it "should create questions" do
    expect {
      @survey.build
    }.to change(Question, :count).by(@survey_data.size)
  end

  it "should create answers" do
    total_of_answers = 8
    expect {
      @survey.build
    }.to change(Answer, :count).by(total_of_answers)
  end

  it "should create weights" do
    total_of_weights = 4
    expect {
      @survey.build
    }.to change(Weight, :count).by(total_of_weights)
  end

  it "should create profiles" do
    total_of_profiles = 2
    expect {
      @survey.build
    }.to change(Profile, :count).by(total_of_profiles)
  end
end
