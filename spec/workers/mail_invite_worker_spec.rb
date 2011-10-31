# -*- encoding : utf-8 -*-
require "spec_helper"

describe MailInviteWorker do
  it "should send the invite e-mail given an invite id" do
    invite = FactoryGirl.create(:invite)
    
    template = double(:template)
    template.stub(:html).and_return('__invite_link__')
    Mailee::Template.stub(:find).and_return(template)
    
    described_class.should_receive(:accept_invitation_url).with(invite.member_invite_token).and_return('site/convite')
    
    described_class.stub(:configuration).and_return({mailee: 'config', subject: '__inviter_name__', template_id: 1234})
    Mailee::Message.should_receive(:create).with({mailee: 'config', subject: invite.member_name, emails: invite.email, html: 'site/convite' })
    
    described_class.perform(invite.id)
  end
end
