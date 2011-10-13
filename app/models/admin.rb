class Admin < ActiveRecord::Base
  ROLES = %w[admin stylist]

  devise :database_authenticatable, :rememberable, :trackable, :validatable, :timeoutable, :lockable
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def admin?
    self.role == "admin"
  end

  def stylist?
    self.role == "stylist"
  end
end
