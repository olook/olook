# -*- encoding : utf-8 -*-
class Credit < ActiveRecord::Base
  belongs_to :user_credit
  belongs_to :order
  has_many :debits, :class_name => "Credit", :foreign_key => "original_credit_id"
  validates :value, :presence => true
  belongs_to :user

  INVITE_BONUS = BigDecimal.new("10.00")
  
  def description_for(kind)
    case kind
    when :invite
      description_for_invite
    when :used_credit
      description_for_used_credit
    when :loyalty
      description_for_loyalty
    when :redeem
      description_for_redeem
    end
  end
  
  private
  def description_for_invite
    if (source == "inviter_bonus")
      "Ganho por se cadastrar via convite"
    elsif (source == "invitee_bonus")
      "Amiga se cadastrou e fez compra #{order.number}"
    elsif order
      "Acerto via SAC com pedido #{order.id}"
    else
      "Acerto via SAC"
    end
  end
  
  def description_for_used_credit
   "Compra #{order.try(:id)}"
  end
  
  def description_for_loyalty
    if (source == "loyalty_program_credit")
      "Ganho pela compra #{order.id}"
    else
      "Credito residual pela compra #{order.id}"
    end
  end
  
  def description_for_redeem
    if order
      "Acerto via SAC com pedido #{order.id}"
    else
      "Acerto via SAC"
    end
  end
end