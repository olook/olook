# -*- encoding : utf-8 -*-
require "spec_helper"

describe SurveyQuestions do
  let(:question) { double }
  let(:fake_questions) { [question, 2, 3, 4, 5, 6, 7] }
  subject { SurveyQuestions.new(fake_questions) }

  xit "should return common questions" do
    subject.common_questions.should == [question, 2]
  end

  xit "should return shoe question" do
    subject.word_question.should == 4
  end

  xit "should return word question" do
    subject.shoe_question.should == 3
  end

  xit "should return shoe size question" do
    subject.shoe_size_question.should == 6
  end

  xit "should return dress size question" do
    subject.dress_size_question.should == 7
  end

  xit "should return id of the first question" do
    question.stub(:id).and_return(1)
    subject.id_first_question.should == 1
  end
end
