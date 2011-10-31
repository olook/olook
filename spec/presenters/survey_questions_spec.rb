# -*- encoding : utf-8 -*-
require "spec_helper"

describe SurveyQuestions do
  let(:question) { double }
  let(:questions) { (1..29).to_a }
  subject { SurveyQuestions.new(questions) }

  it "should return common questions" do
    subject.common_questions.should == questions[0..20]
  end

  it "should return word question" do
    subject.word_question.should == questions[22]
  end

  it "should return show question" do
    subject.shoe_question.should == questions[21]
  end

  it "should return shoe size question" do
    subject.shoe_size_question.should == questions[27]
  end

  it "should return dress size question" do
    subject.dress_size_question.should == questions[28]
  end

  it "should return id of the first question" do
    question.stub(:id).and_return(1)
    questions[0] = question
    subject.id_first_question.should == 1
  end
end
