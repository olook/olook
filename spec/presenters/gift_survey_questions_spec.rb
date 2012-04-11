# -*- encoding : utf-8 -*-
require "spec_helper"

describe GiftSurveyQuestions do
  let(:question) { double }
  let(:questions) { (1..5).to_a }
  subject { described_class.new(questions) }

  describe "#common_questions" do
    it "returns the common questions" do
      subject.common_questions.should == questions[0..3]
    end
  end

  describe "#heel_height_question" do
    it "returns heel height question" do
      subject.heel_height_question.should == questions[4]
    end
  end

  describe "#shoe_size_question" do
    it "returns shoe size question" do
      subject.shoe_size_question.should == questions[5]
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
