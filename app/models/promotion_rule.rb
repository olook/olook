# -*- encoding : utf-8 -*-
class PromotionRule < ActiveRecord::Base

  validates :name, :type, :presence => true

  def matches? attributes={}
    raise "You should call matches? on inherited classes"
  end

end
