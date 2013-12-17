require 'spec_helper'

describe "admin/itineraries/new" do
  before(:each) do
    assign(:admin_itinerary, stub_model(Admin::Itinerary,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new admin_itinerary form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_itineraries_path, :method => "post" do
      assert_select "input#admin_itinerary_name", :name => "admin_itinerary[name]"
    end
  end
end
