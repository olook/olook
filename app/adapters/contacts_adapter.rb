# -*- encoding : utf-8 -*-
class ContactsAdapter
  attr_accessor :login, :password, :oauth_token, :oauth_secret, :oauth_verifier

  TYPE = {gmail: "gmail", yahoo: "yahoo"}

  def initialize(login=nil, password=nil, oauth_token=nil, oauth_secret=nil, oauth_verifier=nil)
    @login, @password = login, password
    @oauth_token, @oauth_secret, @oauth_verifier = oauth_token, oauth_secret, oauth_verifier
  end

  def contacts(type)
    contacts = (type == TYPE[:gmail]) ? Contacts::Gmail.new(login, password).contacts : OauthImport::Yahoo.new.contacts(oauth_token, oauth_secret, oauth_verifier)
  end
end
