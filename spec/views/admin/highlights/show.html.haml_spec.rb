require 'spec_helper'

describe "admin/highlights/show" do
  before(:each) do
    @admin_highlight = assign(:admin_highlight, stub_model(Admin::Highlight))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
