# -*- encoding : utf-8 -*-
class Credit < ActiveRecord::Base
  belongs_to :user_credit
  belongs_to :order
  has_many :debits, :class_name => "Credit", :foreign_key => "original_credit_id"
  validates :value, :presence => true
  belongs_to :user

  INVITE_BONUS = BigDecimal.new("10.00")
end