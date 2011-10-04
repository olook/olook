# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Member can send invites", %q{
  In order to show my showroom for my girlfriends
  As a member
  I want to invite people to join the site
} do
  describe "When a member" do
    background do
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

      scenario "sending an invitation e-mail to a list of people" do
        emails = ['jane@friend.com', 'invalid email', 'mary@friend.com']
        fill_in "invite_mail_list", :with => emails.join(' , ')

        @member.invites.map(&:email).should_not include(emails)

        click_on "Enviar convites"

        page.should have_content("Convites enviados com sucesso!")
        @member.reload
        @member.invites.map(&:email).should =~ ['jane@friend.com', 'mary@friend.com']
      end
    end
  end

  describe "On the invite page, a member can invite people by" do
    scenario "copying and pasting a link" do
      visit member_invite_path
      page.should have_content(@member.invite_token)
    end

    scenario "tweeting the link" do
      visit member_invite_path
      tweet_text = page.find('.twitter-share-button')[:"data-text"]
      tweet_text.should have_content("olook.com/invite/#{@member.invite_token}")
    end

    scenario "posting the link on her Facebook wall" do
      visit member_invite_path
      tweet_text = page.find('.fb-send')[:"data-href"]
      tweet_text.should have_content("olook.com/invite/#{@member.invite_token}")
    end
  end
end
