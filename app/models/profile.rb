# -*- encoding : utf-8 -*-
class Profile < ActiveRecord::Base
  has_many :points
  has_many :users, :through => :points
  has_many :weights
  has_many :answers, :through => :weights
  
  validates_presence_of :name, :first_visit_banner
end
