class ContactsAdapter
  TYPE = {gmail: "1", yahoo: "2"}
  attr_accessor :login, :password

  def initialize(login, password)
    @login, @password = login, password
  end

  def contacts(type)
    contacts = (type == TYPE[:gmail]) ? Contacts::Gmail.new(login, password).contacts : Contacts::Yahoo.new(login, password).contacts
  end
end
