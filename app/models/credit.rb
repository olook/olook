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
      "Cadastro realizado em #{l self.created_at}"
    elsif (source == "invitee_bonus")
      if order && order.user
      "#{order.user.email} (compra realizada em #{l self.created_at})"
      else
        "Compra realizada em #{l self.created_at}"
      end
    end
  end
  
  def description_for_used_credit
   "Compra realizada em #{l self.created_at}"
  end
  
  def description_for_loyalty
    "Compra realizada em #{l self.created_at}. Crédito disponível de #{l self.activates_at} a #{l self.expires_at}"
  end
  
  def description_for_redeem
    if order
      "Compra realizada em #{l self.created_at}"
    else
      "Créditos concedidos pela Central de Atendimento"
    end
  end
  
  def l(date)
    I18n.localize date, :format => "%d/%m/%Y"
  end
end