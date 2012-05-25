# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SurveyBuilder do
  before :each do
    casual = {:name => "Casual", :banner => "casual" }
    sporty = {:name => "Sporty", :banner => "sporty" }
    @survey_data = []
    @survey_data[0] = {
      :question_title => "Question one",
      :answers => (1..3).to_a,
      :weights => [{ 1 => {"10" => casual, "5" => sporty}},
                   { 2 => {"5" => sporty, "10" => casual}}]
    }

    @survey_data[1] = {
      :question_title => "Question two",
      :answers => (1..5).to_a,
      :weights => []
    }

  end

  subject { described_class.new(@survey_data, "Registration Survey") }

  it "finds or creates a new survey with the received name" do
    name = "Survey name"
    Survey.should_receive(:find_or_create_by_name).with(name)

    described_class.new(@survey_data, name)
  end

  it "creates the survey questions" do
    expect {
      subject.build
    }.to change { subject.survey.questions.count }.by(@survey_data.size)
  end

  it "creates the survey answers for each question" do
    total_of_answers = 8
    expect {
      subject.build
    }.to change { Answer.count }.by(total_of_answers)
  end

  it "create the weights for then answers" do
    total_of_weights = 4
    expect {
      subject.build
    }.to change { Weight.count }.by(total_of_weights)
  end

  it "creates the profiles associated with the weights" do
    total_of_profiles = 2
    expect {
      subject.build
    }.to change { Profile.count }.by(total_of_profiles)
  end
end
