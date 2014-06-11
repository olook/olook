# encoding: utf-8
class LoyaltyProgramCreditType < CreditType
  DAYS_TO_EXPIRE = 31.days

  def self.percentage_for_order
    BigDecimal.new(Setting.percentage_on_order)
  end

  def self.amount_for_order(order)
    amount_for_redeem = order.redeem_payment.total_paid if order.redeem_payment
    amount_for_redeem ||= 0

    (amount_for_redeem + order.amount_paid) * LoyaltyProgramCreditType.percentage_for_order
  end

  def self.apply_percentage(amount)
    amount * self.percentage_for_order
  end

  def credit_sum(user_credit, date, is_debit, kind, source=nil)
    select_credits(user_credit, date, is_debit, kind).sum(:value)
  end

  def remove(opts)
    user_credit, total_amount = opts.delete(:user_credit), opts.delete(:value)
    if user_credit.total >= total_amount
      credits = select_credits_for_debits(user_credit, total_amount)
      credits.inject([]) do |result, (credit, amount_available)|
        if total_amount <= 0  || amount_available <= 0
          result
        else
          if amount_available >= total_amount
            amount_available = total_amount
          end

          total_amount -= amount_available

          result << credit.debits.create!(opts.merge({
            :source => "loyalty_program_debit",
            :is_debit => true,
            :value => amount_available,
            :expires_at => credit.expires_at,
            :activates_at => credit.activates_at,
            :user_credit_id => user_credit.id
          }))
        end
      end
    else
      false
    end
  end

  def add(opts)
    super(opts.merge({
      :activates_at => period_start,
      :expires_at => period_end,
      :source => "loyalty_program_credit"
    }))
  end

  def self.credit_amount_to_expire(user_credit, date=Time.zone.now.end_of_month)
    expires_at = Credit.arel_table[:expires_at]
    credits = user_credit.credits.where(expires_at.lteq(date +1.day)).where(expires_at.gteq(date -1.day )).where(is_debit: 0)

    credits.inject(0){|v,c| v+=(c.value - c.debits.sum(:value))}
  end

  private

  def select_credits(user_credit, date, is_debit, kind = :available)
    if (kind == :available)
      user_credit.credits.where("activates_at <= ? AND expires_at >= ? AND is_debit = ?",
                                date, date, is_debit)
    else
      user_credit.credits.where("activates_at > ? AND is_debit = ?",
                                date, is_debit)
    end
  end

  def select_credits_for_debits(user_credit, amount)
    catch(:sufficient_amount) do
      credit_availables = {}
      select_credits(user_credit, Time.zone.now, 0).order('activates_at').find_each do |credit|
        amount_available_for_credit = credit.amount_available?
        if  amount_available_for_credit > 0
          credit_availables.merge!(credit => amount_available_for_credit)
        end
        throw(:sufficient_amount, credit_availables) if credit_availables.values.sum  >= amount
      end
    end
  end


  def period_start
    Time.zone.now.at_midnight
  end

  def period_end(date = Time.zone.now)
    (Time.zone.now + DAYS_TO_EXPIRE).at_midnight
  end

end
