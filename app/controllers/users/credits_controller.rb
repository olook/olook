# -*- encoding : utf-8 -*-
class Users::CreditsController < ApplicationController

  respond_to :html
  before_filter :authenticate_user!

  def index
    report  = CreditReportService.new(@user)
    @loyalty_credits = report.loyalty_credits
    @invite_credits  = report.invite_credits
    @redeem_credits  = report.redeem_credits
    @used_credits    = report.used_credits
    @refunded_credits = report.refunded_credits
    @available_credits = report.available_credits
    @holding_credits = report.holding_credits
  end
  
end

