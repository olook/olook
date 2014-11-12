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

  def send_expiration_warning (user, expires_tomorrow = false, date=Date.tomorrow)
    @user = user

    # Calculates available credits
    user_credit = user.user_credits_for(:loyalty_program)
    @credit_amount = LoyaltyProgramCreditType.credit_amount_to_expire(user_credit, date)

    if @credit_amount > 0
      @date = date - 1.day
      subject = "Corra #{user.first_name}, seus R$ #{('%.2f' % @credit_amount).gsub('.',',')} em créditos expiram em sete dias!"

      @user = user
      mail(:to => @user.email, :subject => subject)
    end
  end

end
