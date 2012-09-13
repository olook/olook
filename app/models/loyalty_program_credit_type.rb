# encoding: utf-8
class LoyaltyProgramCreditType < CreditType

  def self.percentage_for_order 
    BigDecimal.new(Setting.percentage_on_order)
  end

  def self.apply_percentage(amount)
    amount * self.percentage_for_order
  end
  
  def credit_sum(user_credit, date, is_debit, kind)
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
      select_credits(user_credit, DateTime.now, 0).order('activates_at').find_each do |credit|
        amount_available_for_credit = credit.amount_available?
        if  amount_available_for_credit > 0
          credit_availables.merge!(credit => amount_available_for_credit)
        end
        throw(:sufficient_amount, credit_availables) if credit_availables.values.sum  >= amount
      end
    end
  end
  

  def period_start(date = DateTime.now)
    date += 1.month
    date.at_beginning_of_month
  end

  def period_end(date = DateTime.now)
    date += 2.months
    date.at_end_of_month
  end


end
