require 'spec_helper'
require 'integration/helpers'

feature "Admin user executing actions on the system", %q{
  A logged admin should be able to perform only allowed actions
} do

  before :each do
    @sac_operator = Factory(:sac_operator)
    @superadministrator = Factory(:superadministrator)
  end

  scenario "Admin can't perform an action he is not allowed to" do
    pending
  end

  scenario "Admin can perform an action on models he is allowed to" do
    pending
  end

end