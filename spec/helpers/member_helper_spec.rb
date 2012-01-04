# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MemberHelper do

  it "should return the tweet message" do
    member = double("member")
    fake_invite_token = 'XyXyXy'
    member.stub(:invite_token) { fake_invite_token }
    helper.link_to_invitation(member).should include(fake_invite_token)
  end

  it '#link_to_invitation should generate a message and a link' do
    member = double("member")
    fake_invite_token = 'XyXyXy'
    member.stub(:invite_token) { fake_invite_token }
    helper.link_to_invitation(member).should include(fake_invite_token)
  end

  it '#invitation_link should generate a link with the invite_token of the inviting member' do
    member = double("member")
    fake_invite_token = 'XyXyXy'
    member.stub(:invite_token) { fake_invite_token }
    helper.invitation_link(member).should include(fake_invite_token)
  end

  it '#invite_message should return a text string' do
    helper.invite_message.should be_true
  end
  
  describe '#display_member_invite_bonus' do
    let(:member) { double(User) }

    it 'should return member_with_no_invite_bonus when the member invite_bonus is zero' do
      member.stub(:invite_bonus).and_return(0.0)
      helper.display_member_invite_bonus(member).should == I18n.t('views.members.member_with_no_invite_bonus')
    end

    it 'should return member_with_invite_bonus when the member invite_bonus is greater than zero' do
      member.stub(:invite_bonus).and_return(290.0)
      helper.display_member_invite_bonus(member).should == I18n.t('views.members.member_with_invite_bonus', :bonus => number_to_currency(member.invite_bonus))
    end
  end

  describe "#invitation_score" do
    let(:member) { double(User) }
    
    describe "when no invite was accepted" do
      context "for a member who wasn't invited" do
        it 'should return no_invite_accept message' do
          member.stub(:'is_invited?').and_return(false)
          member.stub(:invite_bonus).and_return(0.0)
          member.stub_chain(:invites, :accepted, :count).and_return(0)
          helper.invitation_score(member).should == I18n.t('views.members.no_invitation_accepted')
        end
      end

      context "for a member who was invited" do
        it 'should return bonus_for_accepting_invite message' do
          member.stub(:'is_invited?').and_return(true)
          member.stub(:invite_bonus).and_return(100.0)
          member.stub_chain(:invites, :accepted, :count).and_return(0)
          helper.invitation_score(member).should == I18n.t('views.members.bonus_for_accepting_invite')
        end
      end
    end

    describe "when some invites were accepted" do
      before :each do
        member.stub(:invite_bonus).and_return(100.0)
      end
      it 'should return the singular invitation_accepted message when 1 invite was accepted' do
        member.stub_chain(:invites, :accepted, :count).and_return(1)
        helper.invitation_score(member).should == I18n.t('views.members.invitation_accepted', :count => 1, :bonus => number_to_currency(member.invite_bonus))
      end
      it 'should return the plural invitation_accepted message when more than 1 invite was accepted' do
        member.stub_chain(:invites, :accepted, :count).and_return(2)
        helper.invitation_score(member).should == I18n.t('views.members.invitation_accepted', :count => 2, :bonus => number_to_currency(member.invite_bonus))
      end
    end
  end

  describe "#first_visit_banner" do
    let(:casual_profile) { FactoryGirl.create(:casual_profile) }

    it "should return the banner associated with the user first profile" do
      helper.stub_chain(:current_user, :profile_scores, :first, :try).and_return(casual_profile)
      helper.first_visit_banner.should == "/assets/first_visit_banner/casual.jpg"
    end
  end

  describe "#domain_url" do
    it "should return the domain url" do
      helper.domain_url.should == "http://www.olook.com.br"
    end
  end

  require File.expand_path('spec/spec_helper')
  
  describe "#first_visit_profile" do
    let(:casual_profile) { FactoryGirl.create(:casual_profile) }

    it "should return the user first profile" do
      helper.stub_chain(:current_user, :profile_scores, :first, :try, :first_visit_banner).and_return(casual_profile.first_visit_banner)
      helper.first_visit_profile.should == "casual"
    end
  end
end
