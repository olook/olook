require 'spec_helper'

describe Admin::UtilitiesController, admin: true do
  render_views

  describe "GET index" do
    it "should open index properly" do
      response.should be_success
    end
  end

end
