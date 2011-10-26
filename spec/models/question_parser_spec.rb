require "spec_helper"

describe do QuestionParser

  let(:questions) { questions = {
      question_45:  '151',
      question_46:  '154',
      question_47_161: '161',
      question_47_162: '162'
    }
  }

  it "should parse the questions and return just the id as indice" do
    parser = QuestionParser.new(questions)
    expected = [{"45" => '151'}, {"46" => '154'}, {"47" => '161'}, {"47" => '162'}]
    parser.parse.should == expected
  end

  it "should return questions ids" do
    parser = QuestionParser.new(questions)
    parser.get_questions_ids.should == ["45", "46", "47", "47"]
  end

  it "should return answers ids" do
    parser = QuestionParser.new(questions)
    parser.get_answers_ids.should == ["151", "154", "161", "162"]
  end
end
