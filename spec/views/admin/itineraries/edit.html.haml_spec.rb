require 'spec_helper'

describe "admin/itineraries/edit" do
  before(:each) do
    @admin_itinerary = assign(:admin_itinerary, stub_model(Admin::Itinerary,
      :name => "MyString"
    ))
  end

  it "renders the edit admin_itinerary form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_itineraries_path(@admin_itinerary), :method => "post" do
      assert_select "input#admin_itinerary_name", :name => "admin_itinerary[name]"
    end
  end
end
