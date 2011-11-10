# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ContactsAdapter do
  let(:credentials) { {login: 'foo', password: 'bar'} }
  let(:oauth) { {token: 'lasjhfl', secret: 'lasjhfl', verifier: 'lasjhfl'} }
  let(:adapter) { ContactsAdapter.new(credentials[:login], credentials[:password], oauth[:token], oauth[:secret], oauth[:verifier]) }

  it "should return contacts from Yahoo" do
    Contacts::Gmail.should_receive(:new).with(credentials[:login], credentials[:password]).and_return(gmail_contacts = mock)
    gmail_contacts.should_receive(:contacts)
    adapter.contacts(ContactsAdapter::TYPE[:gmail])
  end

  it "should return contacts from Yahoo" do
    OauthImport::Yahoo.stub(:new).and_return(oauth_import_yahoo = mock)
    oauth_import_yahoo.should_receive(:contacts).with(oauth[:token], oauth[:secret], oauth[:verifier])
    adapter.contacts(ContactsAdapter::TYPE[:yahoo])
  end
end
