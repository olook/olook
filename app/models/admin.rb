# == Schema Information
#
# Table name: admins
#
#  id                  :integer          not null, primary key
#  email               :string(255)      default(""), not null
#  encrypted_password  :string(128)      default(""), not null
#  failed_attempts     :integer          default(0)
#  unlock_token        :string(255)
#  locked_at           :datetime
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  remember_created_at :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  first_name          :string(255)
#  last_name           :string(255)
#  role_id             :integer
#

# -*- encoding : utf-8 -*-
class Admin < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me,
                  :role_id
  belongs_to :role

  # TODO: Temporarily disabling paper_trail for app analysis
  # has_paper_trail :on => [:update, :destroy]


  EmailFormat = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  NameFormat = /^[A-ZÀ-ÿ\s-]+$/i


  devise :database_authenticatable, :rememberable, :trackable, :validatable, :timeoutable, :lockable

  validates :role_id, :presence => true
  validates :email, :format => {:with => EmailFormat}
  validates :first_name, :presence => true, :format => { :with => NameFormat }
  validates :last_name, :presence => true, :format => { :with => NameFormat }


  def name
    "#{first_name} #{last_name}".strip
  end

  def has_role?(role_name)
    self.role.name.to_sym == role_name if self.role
  end


end
