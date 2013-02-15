# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Half User accessing home", %q{
  In order to avoid bad impression from client when seeing an error
  As a half user
  I want to correctly see the home page
} do

  scenario "Access home page (being redirect to members#showroom) as a female half user" do
    half_user = FactoryGirl.create(:user, half_user: true, gender: 0)
    do_login!(half_user)
    visit root_url

    expect(page.status_code).to eql(200)
  end

end
