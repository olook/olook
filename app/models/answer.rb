# -*- encoding : utf-8 -*-
class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :weights
  has_many :profiles, :through => :weights
end
