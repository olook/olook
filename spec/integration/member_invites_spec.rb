require 'spec_helper'
require 'integration/helpers'

feature "Members can send invites", %q{
  In order to show my showroom for my girlfriends
  As a member
  I want to invite people to join the site
} do
  
  describe "When a member" do
    background do
      User.any_instance.stub(:counts_and_write_points)
      answer_survey

      email = "member.jane@doe.com"
      pass = "123abc"
      visit new_user_registration_path
      fill_in "user_name", :with => "Name"
      fill_in "user_email", :with => email
      fill_in "user_password", :with => pass
      fill_in "user_password_confirmation", :with => pass
      click_on "Sign up"
      page.should have_content(I18n.t "devise.registrations.signed_up")
      click_on "Logout"
      page.should have_content(I18n.t "devise.sessions.signed_out")
      visit new_user_session_path
      fill_in "user_email", :with => email
      fill_in "user_password", :with => pass
      click_button "Sign in"
      page.should have_content(I18n.t "devise.sessions.signed_in")
      @member = User.find_by_email(email)
    end  

    scenario "access the welcome page, they should be able to go to the invite page" do
      visit welcome_path
      page.has_link?("Convide suas amigas", :href => member_invite_path)
    end

    describe "access the invite page, they can invite people by" do 
      background do
        visit member_invite_path
      end

      scenario "copying and pasting a link to invite/*invite_token*" do 
        share_link = page.find('span#share_invitation')
        share_link.should have_content(accept_invitation_path(:invite_token => @member.invite_token))
      end

      scenario "tweeting the link" do
        tweet_text = page.find('.twitter-share-button')[:"data-text"]
        tweet_text.should have_content("olook.com/invite/#{@member.invite_token}")
      end

      scenario "posting the link on her Facebook wall" do
        facebook_button = page.find('.fb-send')[:"data-href"]
        facebook_button.should have_content("olook.com/invite/#{@member.invite_token}")
      end
    end
  end

  describe "When a visitor accepts the invitation and click on the invite link" do
    background do
      # Make sure it behaves like a visitor
      delete destroy_user_session_path
    end

    describe "they should be redirected to the home page" do
      scenario "if they have an empty token" do
        visit accept_invitation_path(:invite_token => '')
        current_path.should == root_path
        page.should have_content("Invalid token")
      end

      scenario "if they have a token with an invalid format" do
        visit accept_invitation_path(:invite_token => '')
        current_path.should == root_path
        page.should have_content("Invalid token")
      end

      scenario "if they have a token that doesn't exist" do
        visit accept_invitation_path(:invite_token => 'X'*20)
        current_path.should == root_path
        page.should have_content("Invalid token")
      end
    end
    
    describe "they should be redirected to the survey page with invite details" do
      scenario "if they have a valid token" do
        inviting_member = FactoryGirl.create(:member)
        visit accept_invitation_path(:invite_token => inviting_member.invite_token)
        current_path.should == survey_index_path
        page.should have_content(inviting_member.name)
      end
    end
  end
end
