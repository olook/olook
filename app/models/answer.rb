# -*- encoding : utf-8 -*-
class Answer < ActiveRecord::Base
  belongs_to :question, :dependent => :destroy
  has_many :weights
  has_many :profiles, :through => :weights
end
