# -*- encoding : utf-8 -*-
class Cart < ActiveRecord::Base
  belongs_to :user
  has_one :order
  has_many :cart_items
end