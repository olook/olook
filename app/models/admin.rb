# -*- encoding : utf-8 -*-
class Admin < ActiveRecord::Base

  attr_accessible :role_attributes
  belongs_to :role
  accepts_nested_attributes_for :role

  has_paper_trail :on => [:update, :destroy]


  EmailFormat = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  NameFormat = /^[A-ZÀ-ÿ\s-]+$/i


  devise :database_authenticatable, :rememberable, :trackable, :validatable, :timeoutable, :lockable
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :role_attributes

  validates :role_id, :presence => true
  validates :email, :format => {:with => EmailFormat}
  validates :first_name, :presence => true, :format => { :with => NameFormat }
  validates :last_name, :presence => true, :format => { :with => NameFormat }

  def role_attributes=(attr)
    self.role = Role.find_by_id(attr["id"])
  end  

  def has_role?(role_name)
    self.role.name.to_sym == role_name if self.role
  end


end
