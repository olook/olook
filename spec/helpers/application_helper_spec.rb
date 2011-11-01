require 'spec_helper'

describe ApplicationHelper do
  it "should " do
    expected = "<link href=\"/assets/application.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />"
    helper.stylesheet_application.should eq(expected)
  end
end
