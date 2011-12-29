# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::UserExportMailer do
  describe "#csv_ready" do
    let(:email) { "user@example.com" }
    subject { Admin::UserExportMailer.csv_ready(email) }

    it "sets 'from' attribute to Admin Olook <admin@olook.com.br>" do
      subject.from.should include("admin@olook.com.br")
    end

    it "sets 'to' attribute to received email" do
      subject.to.should include(email)
    end

    it "sets 'subject' attribute informing the CSV file is ready" do
      subject.subject.should == "Arquivo CSV com os usuários está pronto"
    end

    it "should include the CSV url in e-mails's body" do
      subject.body.encoded.should match("http://app1.olook.com.br/admin/users.csv")
    end
  end
end
