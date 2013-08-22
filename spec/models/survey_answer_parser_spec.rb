# -*- encoding : utf-8 -*-
require "spec_helper"

describe SurveyAnswerParser do

  let(:questions) { questions = {
      "question_45" => '151',
      "question_46" =>  '154',
      "question_47_161" => '161',
      "question_47_162" => '162',
      "day" => '5',
      "month" => '9',
      "year" => '1984'
    }
  }

  it "should parse the questions and return just the id as indice" do
    parser = SurveyAnswerParser.new(questions)
    expected = [{"45" => '151'}, {"46" => '154'}, {"47" => '161'}, {"47" => '162'}]
    parser.parse.should == expected
  end

  it "should return questions ids" do
    parser = SurveyAnswerParser.new(questions)
    parser.get_questions_ids.should == ["45", "46", "47", "47"]
  end

  it "should return answers ids" do
    parser = SurveyAnswerParser.new(questions)
    parser.get_answers_ids.should == ["151", "154", "161", "162"]
  end

  it "should build questions objects mapped with answers objects" do
    survey    = FactoryGirl.create(:survey)
    question1 = FactoryGirl.create(:question, :survey => survey)
    question2 = FactoryGirl.create(:question, :survey => survey)
    answer1   = FactoryGirl.create(:answer_from_casual_profile, :question => question1)
    answer2   = FactoryGirl.create(:answer_from_sporty_profile, :question => question2)

    questions = {
      "question_#{question1.id}_#{answer1.id}" => answer1.id,
      "question_#{question2.id}_#{answer2.id}" => answer2.id,
      "question_#{question2.id}_#{answer1.id}" => answer1.id,
    }
    parser = SurveyAnswerParser.new(questions)
    expected = [
      {:question => question1, :answer => answer1},
      {:question => question2, :answer => answer2},
      {:question => question2, :answer => answer1}
    ]
    parser.build_survey_answers.should == expected
  end
end
