# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Question do
  it "should create a question" do
    Question.create!(:title => "Foo Question")
  end
  
  describe 'answers should be ordered by question_id, order and id' do
    subject { FactoryGirl.create :question }
    
    context 'when answers have the order attribute filled' do
      let!(:last_answer) { subject.answers.create title: 'Last', order: 99 }
      let!(:second_answer) { subject.answers.create title: 'Second', order: 2 }
      let!(:first_answer) { subject.answers.create title: 'First', order: 1 }
      
      it 'the first item should have the smallest order number' do
        first_answer.id.should > second_answer.id
        subject.answers.first.should == first_answer
      end

      it 'the second item should have the greatest order number' do
        last_answer.id.should < first_answer.id
        subject.answers.last.should == last_answer
      end
    end
    
    context "when answers don't have the order attribute filled, it should order by answer id" do
      let!(:first_answer) { subject.answers.create title: 'First' }
      let!(:second_answer) { subject.answers.create title: 'Second' }
      let!(:last_answer) { subject.answers.create title: 'Last' }

      it 'the first item should have the smallest id' do
        first_answer.id.should < second_answer.id
        subject.answers.first.should == first_answer
      end

      it 'the second item should have the greatest id' do
        last_answer.id.should > first_answer.id
        subject.answers.last.should == last_answer
      end
    end
  end
end
