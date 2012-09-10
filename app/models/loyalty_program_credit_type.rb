# encoding: utf-8
class LoyaltyProgramCreditType < CreditType

  PERCENTAGE_ON_ORDER = 0.20
  
  def credit_sum(user_credit, date, is_debit)
  	user_credits(user_credit, date, is_debit).sum(:value)
  end

  #TODO: create a mechanism that nullifies the available credits until the debit is paid
  def remove(opts)
    user_credit, amount, order = opts.delete(:user_credit), opts.delete(:value), opts.delete(:order)

    if user_credit.total >= amount
      build_debits(selected_credits(amount,user_credit), amount)
    else
      false
    end
  end

  def add(opts)
    super(opts.merge({
      :activates_at => period_start, 
      :expires_at => period_end,
    }))
  end

  private

    def period_start(date = DateTime.now)
      date += 1.month
      date.at_beginning_of_month
    end

    def period_end(date = DateTime.now)
      date += 2.months
      date.at_end_of_month
    end

    def user_credits(user_credit, date, is_debit)
      user_credit.credits.where("activates_at <= ? AND expires_at >= ? AND is_debit = ?", date, date, is_debit).order('expires_at desc')
    end

  def build_debits(credits, amount)
    total_of_credits    = credits.map(&:value).sum
    special_debit_value = total_of_credits - amount

    if special_debit_value.zero?
      create_credits(credits)
    else
      [
        create_credits(credits),
        create_special_credit(credits.last, special_debit_value)
      ].flatten
    end
  end

  def selected_credits(amount, user_credit)
    catch(:sufficient_amount) do
      credits = {}
      user_credit.credits.where(is_debit: false).order('id desc').find_each do |credit|
        credits.merge!(credit => credit.value)
        throw(:sufficient_amount, credits.keys.sort_by{|c| c.id}.reverse) if credits.values.sum  >= amount
      end
    end
  end

  def default_attrs
    @default_attrs ||= {}
  end

  def create_special_credit(credit, special_debit_value)
    create_credit(credit, default_attrs.merge(:value => special_debit_value, :is_debit => false))
  end

  def create_credits(credits)
    credits.map{|credit| create_credit(credit) }
  end

  def create_credit(credit, opt_attrs=default_attrs)
    debit = credit.dup
    debit.is_debit = true
    debit.original_credit_id = credit.id
    debit.tap{|d| opt_attrs.each_pair{|k,v| d.public_send("#{k}=",v)}; d.save! }
  end    

end
