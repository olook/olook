# -*- encoding : utf-8 -*-
class LoyaltyProgramMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <avisos@olook.com.br>"

  def send_enabled_credits_notification user
    @user = user
    report  = CreditReportService.new(@user)
    @loyalty_credits = report.amount_of_loyalty_credits
    @redeem_credits  = report.amount_of_redeem_credits
    @invite_credits  = report.amount_of_inviter_bonus_credits
    @available_credits = report.available_credits

    mail(:to => @user.email, :subject => "#{user.first_name}, você tem R$ #{('%.2f' % @available_credits).gsub('.',',')} em créditos disponíveis para uso.")
  end

  def send_expiration_warning (user, expires_tomorrow = false)
    @user = user

    # product_finder_service = ProductFinderService.new(user)

    # Gets the showroom products that aren't sold out (#2)
    # products = product_finder_service.showroom_products(:not_allow_sold_out_products => true)

    # Gets the products variants bought by the given user (#1)
    # bought_variants = LineItem.where(:order_id => user.orders).map(&:variant).map(&:product)

    # Excludes #1 from #2 and selects the first product
    # products = products - bought_variants
    @product = nil
    # @product = products.first unless (!products || products.empty?)

    # Calculates available credits
    user_credit = user.user_credits_for(:loyalty_program)
    @credit_amount = LoyaltyProgramCreditType.credit_amount_to_expire(user_credit)

    # Calculates and formats the last day of the month date
    @end_of_month = DateTime.now.end_of_month.strftime("%d/%m/%Y")

    subject = expires_tomorrow ? "Corra #{user.first_name}, seus R$ #{('%.2f' % @credit_amount).gsub('.',',')} em créditos expiram amanhã!" : "#{user.first_name}, seus R$ #{('%.2f' % @credit_amount).gsub('.',',')} em créditos vão expirar!"

    @user = user
    mail(:to => @user.email, :subject => subject) if @credit_amount > 0
  end

end
