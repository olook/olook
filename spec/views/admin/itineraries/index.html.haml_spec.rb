require 'spec_helper'

describe "admin/itineraries/index" do
  before(:each) do
    assign(:admin_itineraries, [
      stub_model(Admin::Itinerary,
        :name => "Name"
      ),
      stub_model(Admin::Itinerary,
        :name => "Name"
      )
    ])
  end

  it "renders a list of admin/itineraries" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
