# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ShowroomReadyNotificationWorker do
  let(:member) { FactoryGirl.create(:member) }
  let(:mock_mail) { mock(:mail).as_null_object }

  it "sets the showroom_ready_mailer queue to process the job" do
    ShowroomReadyNotificationWorker.instance_variable_get("@queue").should == :showroom_ready_mailer
  end

  context "performing work" do

    it "finds the received user by id" do
      MemberMailer.stub(:showroom_ready_email).and_return(mock_mail)

      User.should_receive(:find).with(member.id)
      ShowroomReadyNotificationWorker.perform(member.id)
    end

    it "creates a new showroom ready email for the user" do
      MemberMailer.stub(:showroom_ready_email).and_return(mock_mail)
      User.stub(:find).and_return(member)

      MemberMailer.should_receive(:showroom_ready_email).with(member)
      ShowroomReadyNotificationWorker.perform(member.id)
    end

    it "delivers the created email" do
      mail = double :mail
      MemberMailer.stub(:showroom_ready_email).and_return(mail)

      mail.should_receive(:deliver)
      ShowroomReadyNotificationWorker.perform(member.id)
    end

  end

  it 'should raise "The welcome message for member X was already sent" when receiving a member to whom we sent a member' do

  end
end
