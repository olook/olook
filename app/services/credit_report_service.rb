class CreditReportService
  def initialize(user)
    @user = user
  end

  def loyalty_credits
    @user.user_credits_for(:loyalty_program)
        .credits
        .where(:is_debit => false, :source => "loyalty_program_credit")
        .includes(:order => :user)
        .order("id")
  end
  
  def amount_of_invite_credits
    @user.user_credits_for(:invite).total
  end

  def invite_credits
    @user.user_credits_for(:invite)
         .credits
         .where(:is_debit => false, :source => ["invitee_bonus", "inviter_bonus"])
         .includes(:order => :user)
         .order("id")
  end
  
  def redeem_credits
    @user.user_credits_for(:redeem).credits.where(is_debit:0)
  end

  def amount_of_redeem_credits
    @user.user_credits_for(:redeem).total
  end

  def used_credits
    Credit.joins(:user_credit)
          .where(:user_credits => {:user_id => @user}, :is_debit => true)
          .includes(:order => :user)
          .order("id")
  end

  def amount_of_used_credits
    used_credits.sum(:value)
  end

  def amount_of_loyalty_credits
    @user.user_credits_for(:loyalty_program).total
  end

  def amount_of_inviter_bonus_credits
    @user.user_credits_for(:invite).total(DateTime.now, :available, :invitee_bonus)
  end

  def amount_of_invitee_bonus_credits
    @user.user_credits_for(:invite).total(DateTime.now, :available, :inviter_bonus)
  end

  def quantity_of_inviter_bonus_credits
    #NOTICE Needs to be is_debit false to just retrive the credits gained
    @user.user_credits_for(:invite).credits.where(source: :invitee_bonus, is_debit: 0).count
  end

  def available_credits
    @user.current_credit
  end

  def holding_credits(time=DateTime.now)
    @user.current_credit(time, :holding)
  end

  private
  def scope_for_redeems
   credit_source = Credit.arel_table[:source]
    Credit.joins(:user_credit => :credit_type)
          .where(:user_credits => { :user_id => @user, :credit_types => { :code => ["invite", "redeem"] }})
          .where(credit_source.not_in(["invitee_bonus", "inviter_bonus"]).or(credit_source.eq(nil)))
          .includes(:order => :user)
          .order("id") 
  end
end