require 'spec_helper'

describe ContactsAdapter do
  let(:credentials) { {login: 'foo', password: 'bar'} }
  let(:adapter) { ContactsAdapter.new(credentials[:login], credentials[:password]) }

  it "should return contacts from Yahoo" do
    Contacts::Gmail.should_receive(:new).with(credentials[:login], credentials[:password]).and_return(gmail_contacts = mock)
    gmail_contacts.should_receive(:contacts)
    adapter.contacts(ContactsAdapter::TYPE[:gmail])
  end

  it "should return contacts from Yahoo" do
    Contacts::Yahoo.should_receive(:new).with(credentials[:login], credentials[:password]).and_return(yahoo_contacts = mock)
    yahoo_contacts.should_receive(:contacts)
    adapter.contacts(ContactsAdapter::TYPE[:yahoo])
  end
end
