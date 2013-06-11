require 'spec_helper'

describe "admin/highlights/new" do
  before(:each) do
    assign(:admin_highlight, stub_model(Admin::Highlight).as_new_record)
  end

  it "renders new admin_highlight form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_highlights_path, :method => "post" do
    end
  end
end
