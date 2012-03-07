# -*- encoding : utf-8 -*-
class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  validates :value, :presence => true
end