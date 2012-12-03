# == Schema Information
#
# Table name: answers
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  question_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#  order        :integer
#  picture_name :string(255)
#

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
