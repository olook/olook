class Wholesale

  attr_accessor :first_name, :last_name, :email, :password, :birthday, :gender, :addresses_attributes
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  def persisted?
    false
  end

end
