# -*- encoding : utf-8 -*-
class Users::CreditsController < ApplicationController
  layout "my_account"

  respond_to :html
  before_filter :authenticate_user!

  def index
    @loyalty_credits = @user.user_credits_for(:loyalty_program).credits.where(:is_debit => false).includes(:order).order("id")
    @invite_credits = @user.user_credits_for(:invite).credits.where(:is_debit => false).includes(:order).order("id")
    @redeem_credits = @user.user_credits_for(:redeem).credits.where(:is_debit => false).includes(:order).order("id")
    @used_credits = Credit.joins(:user_credit).where(:user_credits => {:user_id => @user}, :is_debit => true).includes(:order).order("id")
    @available_credits = @user.current_credit
    @holding_credits = @user.current_credit(DateTime.now, :holding)
  end
  
end

