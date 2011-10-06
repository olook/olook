# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Answer do
  before do
    @question = mock_model('Question')
  end

  it "should create an answer" do
    Answer.create!(:title => "Foo Answer", :question_id => @question.id)
  end
end
