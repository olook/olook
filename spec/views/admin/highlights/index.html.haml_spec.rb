require 'spec_helper'

describe "admin/highlights/index" do
  before(:each) do
    assign(:admin_highlights, [
      stub_model(Admin::Highlight),
      stub_model(Admin::Highlight)
    ])
  end

  it "renders a list of admin/highlights" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
