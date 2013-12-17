require 'spec_helper'

describe "admin/itineraries/show" do
  before(:each) do
    @admin_itinerary = assign(:admin_itinerary, stub_model(Admin::Itinerary,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
