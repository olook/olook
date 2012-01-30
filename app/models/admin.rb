# -*- encoding : utf-8 -*-
class Admin < ActiveRecord::Base

   has_and_belongs_to_many :roles

  devise :database_authenticatable, :rememberable, :trackable, :validatable, :timeoutable, :lockable
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def has_role?(role_name)
    self.roles_name.include?(role_name) ? true : false
  end

  def roles_name
    self.roles.collect {|role| role.name.to_sym}
  end

end
