require 'spec_helper'

describe Question do
  it "should create a question" do
    Question.create!(:name => "Foo Question")
  end
end
