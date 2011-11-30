# -*- encoding : utf-8 -*-
class CreditCardsController < ApplicationController
  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order, :only => [:new, :create]
  before_filter :check_freight, :only => [:new, :create]
  before_filter :assign_receipt, :only => [:create]
  before_filter :parse_params, :only => [:create]
  before_filter :build_cart, :only => [:new, :create]
  after_filter  :clean_session_order!, :only => [:create]

  def new
    @payment = CreditCard.new
  end

  def create
    @payment = CreditCard.new(params[:credit_card])

    if @payment.valid?
      order = session[:order].reload
      payment_builder = PaymentBuilder.new(order, @payment)
      @payment = payment_builder.process!
      redirect_to(credit_card_path(@payment), :notice => "Sucesso")
    else
      respond_with(@payment)
    end
  end

  def show
    @payment = @user.payments.find(params[:id])
    @payment_response = @payment.payment_response
  end

  def assign_receipt
    params[:credit_card][:receipt] = Payment::RECEIPT
  end

  private

  def parse_params
    parse_expiration_date_params
    parse_birthday_params
  end

  def parse_expiration_date_params
    year  = params["credit_card"]["expiration_date(1i)"]
    month = params["credit_card"]["expiration_date(2i)"]
    params["credit_card"].merge!("expiration_date" => "#{month}/#{year}")
    1.upto(3) do |i|
      params["credit_card"].delete("expiration_date(#{i}i)")
    end
  end

  def parse_birthday_params
    year  = params["credit_card"]["user_birthday(1i)"]
    month = params["credit_card"]["user_birthday(2i)"]
    day   = params["credit_card"]["user_birthday(3i)"]
    params["credit_card"].merge!("user_birthday" => "#{day}/#{month}/#{year}")
    1.upto(3) do |i|
      params["credit_card"].delete("user_birthday(#{i}i)")
    end
  end
end
