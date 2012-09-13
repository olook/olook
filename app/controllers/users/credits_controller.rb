# -*- encoding : utf-8 -*-
class Users::CreditsController < ApplicationController
  layout "my_account"

  respond_to :html
  before_filter :authenticate_user!

  def index
    @loyalty_credits = @user.user_credits_for(:loyalty_program)
                            .credits
                            .where(:is_debit => false, :source => "loyalty_program_credit")
                            .includes(:order => :user)
                            .order("id")
    
    @invite_credits = @user.user_credits_for(:invite)
                           .credits
                           .where(:is_debit => false, :source => ["invitee_bonus", "inviter_bonus"])
                           .includes(:order => :user)
                           .order("id")
    
    credit_source = Credit.arel_table[:source]
    @redeem_credits = Credit.joins(:user_credit => :credit_type)
                            .where(:is_debit => false)
                            .where(:user_credits => { :user_id => @user, :credit_types => { :code => ["invite", "redeem"] }})
                            .where(credit_source.not_in(["invitee_bonus", "inviter_bonus"]).or(credit_source.eq(nil)))
                            .includes(:order => :user)
                            .order("id")
    
    @used_credits = Credit.joins(:user_credit)
                          .where(:user_credits => {:user_id => @user}, :is_debit => true)
                          .includes(:order => :user)
                          .order("id")
    
    @available_credits = @user.current_credit
    @holding_credits = @user.current_credit(DateTime.now, :holding)
  end
  
end

