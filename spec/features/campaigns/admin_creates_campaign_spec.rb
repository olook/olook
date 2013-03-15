require 'spec_helper'
require 'features/helpers'

feature "Admin user with business 1 role manages gift boxes" do


  before :each do
  	@admin = FactoryGirl.create(:admin_superadministrator)
    @collection = FactoryGirl.create(:inactive_collection)
    Collection.stub_chain(:active, :id)
  end
end
