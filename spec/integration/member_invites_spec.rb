# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Member can send invites", %q{
  In order to show my showroom for my girlfriends
  As a member
  I want to invite people to join the site
} do

  let(:user) { FactoryGirl.create(:user) }

  context "When a member" do
    background do
      do_login!(user)
      SurveyQuestions.stub(:new).and_return(false)
      @member = User.find_by_email(user.email)
    end

    context "access the invite/welcome page" do
      scenario "they should be able to go to the invite page" do
        visit member_invite_path
        page.has_link?("Convide suas amigas", :href => member_invite_path)
      end

      scenario "if they don't have any amount of invite_bonus they should see a message to invite friends" do
        User.any_instance.stub(:invite_bonus).and_return(0.0)
        visit member_invite_path
        page.should have_content("Escolha uma das opções abaixo e comece a convidar")
      end

      scenario "if they have any amount of invite_bonus they should see the ammount they earned" do
        User.any_instance.stub(:invite_bonus).and_return(13.0)
        visit member_invite_path
        page.should have_content('Você já ganhou R$ 13,00')
      end
    end

    describe "access the invite page, they can invite people by" do
      background do
        visit member_invite_path
      end

      scenario "copying and pasting a link to invite/*invite_token*" do
        page.should have_content(accept_invitation_path(:invite_token => @member.invite_token))
      end

      scenario "tweeting the link" do
        tweet_text = page.find('.twitter-share-button')[:"data-text"]
        
        tweet_text.should have_content(accept_invitation_path(:invite_token => @member.invite_token))
      end

      scenario "sending an invitation e-mail to a list of people" do
        emails = ['jane@friend.com', 'invalid email', 'mary@friend.com']
        fill_in "invite_mail_list", :with => emails.join(' , ')

        @member.invites.map(&:email).should_not include(emails)

        click_on "Convidar"

        page.should have_content("2 convites enviados com sucesso!")
        @member.reload
        @member.invites.map(&:email).should =~ ['jane@friend.com', 'mary@friend.com']
      end
    end
  end

  context "When a visitor accepts the invitation and click on the invite link" do
    background do
      # Make sure it behaves like a visitor
      delete destroy_user_session_path
    end

    describe "they should be redirected to the home page" do
      scenario "if they have an empty token" do
        visit accept_invitation_path(:invite_token => '')
        page.should have_content("Convite inválido")
      end

      scenario "if they have a token with an invalid format" do
        visit accept_invitation_path(:invite_token => '')
        page.should have_content("Convite inválido")
      end

      scenario "if they have a token that doesn't exist" do
        visit accept_invitation_path(:invite_token => 'X'*20)
        page.should have_content("Convite inválido")
      end
    end

    describe "they should be redirected to the survey page with invite details" do
      scenario "if they have a valid token" do
        build_survey
        inviting_member = FactoryGirl.create(:member)
        visit accept_invitation_path(:invite_token => inviting_member.invite_token)
        current_path.should == root_path
      end
    end
  end
end
