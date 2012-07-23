# -*- encoding : utf-8 -*-
class Checkout::BaseController < ApplicationController
  layout "checkout"

  before_filter :load_referer
  
  helper_method :current_referer
  def current_referer
    session[:return_to] = case request.referer
      when /produto|sacola/ then
        session[:return_to] ? session[:return_to] : nil
      when /moments/ then
        { text: "Voltar para ocasiões", url: moments_path }
      when /suggestions/ then
        session[:recipient_id] ? { text: "Voltar para as sugestões", url: gift_recipient_suggestions_path(session[:recipient_id]) } : nil
      when /gift/ then
        { text: "Voltar para presentes", url: gift_root_path }
      else
        nil
    end
    
    if @cart.has_gift_items?
      session[:return_to] ||= { text: "Voltar para as sugestões", url: gift_recipient_suggestions_path(session[:recipient_id]) }
    elsif @user && !@user.half_user?
      session[:return_to] ||= { text: "Voltar para a minha vitrine", url: member_showroom_path }
    else
      session[:return_to] ||= { text: "Voltar para tendências", url: lookbooks_path }
    end
  end
  
  private
  def load_referer
    @referer = current_referer
  end
  
  def erase_freight
    @cart.freight = nil
  end

  def check_freight
    redirect_to addresses_path, :notice => "Escolha seu endereço" if @cart.freight.nil?
  end
  
  # def check_cpf
  #   redirect_to(payments_path, :notice => "CPF inválido") unless Cpf.new(params[:user][:cpf]).valido?
  # end
  
  def check_cpf
    redirect_to payments_path, :notice => "Informe seu CPF" unless Cpf.new(@user.cpf).valido?
  end
  
  def check_order
    redirect_to(cart_path, :notice => "Sua sacola está vazia") if @cart.items_total <= 0
  end
end