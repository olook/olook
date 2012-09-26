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
  
  def amount_available?
    self.value - debits.sum(:value)
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
    # the "- 1.hour" is needed, because of DST (Daylight saving time). Ask Rafael for more information
    "Compra realizada em #{l order.created_at}. Crédito disponível de #{l activates_at_with_dst_correction} a #{l expires_at_with_dst_correction}"
  end
  
  def description_for_redeem
    if order
      "Compra realizada em #{l self.created_at}"
    else
      "Crédito concedido pela Central de Atendimento"
    end
  end
  
  def l(date)
    I18n.localize date, :format => "%d/%m/%Y"
  end

  private 

    #
    # These two methods are needed in order to avoid problems with Daylight Savin Time (dst - Horario de Verao).
    # for activates_at:
    # => inside the dst period, all activates_at created will be 1 hour past, so, the date 
    # => (desconsidering the time) will be 1 day in the past
    #
    # for expires_at:
    # => inside the dst period, all expires_at date created, will be 1 hour in the future, so the final date 
    # => (desconsidering the time) will be 1 day in the future
    #
    # TO REMOVE THIS WE MUST BE SURE TO DISABLE ALL DST STUFF FROM MYSQL
    def activates_at_with_dst_correction
      self.activates_at + 4.hour
    end

    def expires_at_with_dst_correction
      self.expires_at - 1.hour
    end
end