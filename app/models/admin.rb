# -*- encoding : utf-8 -*-
class Admin < ActiveRecord::Base

  belongs_to :role
  validates :role_id, :presence => true

  devise :database_authenticatable, :rememberable, :trackable, :validatable, :timeoutable, :lockable
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def has_role?(role_name)
    self.role.name.to_sym == role_name ? true : false
  end


end
