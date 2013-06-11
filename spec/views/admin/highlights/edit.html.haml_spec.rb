require 'spec_helper'

describe "admin/highlights/edit" do
  before(:each) do
    @admin_highlight = assign(:admin_highlight, stub_model(Admin::Highlight))
  end

  it "renders the edit admin_highlight form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_highlights_path(@admin_highlight), :method => "post" do
    end
  end
end
