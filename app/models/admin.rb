class Admin < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :timeoutable, :lockable
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
