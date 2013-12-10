class UserCredit < ActiveRecord::Base
  belongs_to :credit_type
  belongs_to :user
  has_many :credits

  TRANSACTION_LIMIT = 400.0
  CREDIT_CODES = {invite: 'MGM', loyalty_program: 'Fidelidade', redeem: 'Reembolso'}

  def last_credit(date = DateTime.now, is_debit=false, source=nil)
    credit_type.last_credit(self, date, is_debit, source)
  end

  def total(date = DateTime.now, kind = :available, source=nil)
    credit_type.total(self, date, kind, source)
  end

  def add(opts)
    raise ArgumentError.new('Amount is required!') if opts[:amount].nil?

    amount = BigDecimal.new(opts.delete(:amount).to_s)

    opts.merge!({
      :total => (total + amount),
      :user_credit => self,
      :value => amount
    })

    credit_type.add(opts)
  end

  #Set total in the remotion.
  def remove(opts)
    raise ArgumentError.new('Amount is required!') if opts[:amount].nil?

    amount = BigDecimal.new(opts.delete(:amount).to_s)

    credit_type.remove(opts.merge!({
      :user_credit => self,
      :value => amount
    }))
  end

  def self.process!(order)
    # TO DO: Double check to see if the credit was already given for this order

    # creates MGM credits for inviter
    UserCredit.add_invite_credits(order) if Setting.invite_credits_available
    # creates loyalty program credits
    UserCredit.add_loyalty_program_credits(order) if Setting.loyalty_program_credits_available && !order.user.reseller
  end

  def self.add_for_invitee(invitee)
    if invitee.is_invited? && invitee.current_credit == 0
      invitee.user_credits_for(:invite).add({:amount => BigDecimal.new(Setting.invite_credits_bonus_for_invitee), :source => "inviter_bonus"})
      Resque.enqueue_in(1.minute, MailRegisteredInviteeWorker, invitee.id)
      #invitee.try(:inviter) <= manda e-mail para ela
    end
  end

  private
    #NOTICE: sources estao invertidas
    def self.add_invite_credits(order)
      buyer, inviter = order.user, order.user.try(:inviter)

      if inviter && buyer.first_buy?
        inviter.user_credits_for(:invite).add({:amount => BigDecimal.new(Setting.invite_credits_bonus_for_inviter), :order => order, :source => "invitee_bonus"})
        Resque.enqueue_in(1.minute, MailProductPurchasedByInviteeWorker, buyer.id)
        #inviter <= manda e-mail para ela
      end
    end

    def self.add_loyalty_program_credits(order)
      user_credit = order.user.user_credits_for(:loyalty_program)

      user_credit.add({
        :order => order,
        :amount => LoyaltyProgramCreditType.amount_for_order(order),
        :source => "loyalty_program_credit"
      })
    end
end
