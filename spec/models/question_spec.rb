# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Question do
  it "should create a question" do
    Question.create!(:title => "Foo Question")
  end
end
