require 'spec_helper'

describe Gift::SurveyHelper do
  it "returns the question title replacing 'presenteada' with the received gift recipient relation" do
    relation = "sogra"
    question_title = "Qual desses sapatos combina mais com o estilo da sua presenteada?"
    expected = "Qual desses sapatos combina mais com o estilo da sua <span>#{relation}</span>?"
    helper.question_title_for_recipient(question_title, relation).should == expected
  end
end
