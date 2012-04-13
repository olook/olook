# -*- encoding : utf-8 -*-
require "spec_helper"

describe GiftSurveyQuestions do
  let(:question) { double }
  let(:questions) { (1..5).to_a }
  subject { described_class.new(questions) }

  describe "#common_questions" do
    it "returns the common questions" do
      subject.common_questions.should == questions[0..6]
    end
  end

  describe "#id_first_question" do
    it "returns id of the first question" do
      question.stub(:id).and_return(1)
      questions[0] = question
      subject.id_first_question.should == 1
    end
  end
end
