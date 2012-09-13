# encoding: utf-8
class LoyaltyProgramCreditType < CreditType

  def self.percentage_for_order 
    BigDecimal.new(Setting.percentage_on_order)
  end

  def self.apply_percentage(amount)
    amount * self.percentage_for_order
  end
  
  def credit_sum(user_credit, date, is_debit, kind)
    if (kind == :available)
      user_credit.credits.where("activates_at <= ? AND expires_at >= ? AND is_debit = ?", 
                                date, date, is_debit)
                         .sum(:value)
    else
      user_credit.credits.where("activates_at > ? AND is_debit = ?", 
                                date, is_debit)
                         .sum(:value)
    end
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
      :source => "loyalty_program_credit"
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

  def build_debits(credits, amount)
    total_of_credits    = credits.map(&:value).sum
    special_debit_value = total_of_credits - amount

    if special_debit_value.zero?
      create_credits(credits)
    else
      [
        create_credits(credits),
        create_remainder(credits.last, special_debit_value)
      ].flatten
    end
  end

  def selected_credits(amount, user_credit)
    #LEVAR EXPIRES_AT EM CONSIDERACAO E SE JA FOI USADO !
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

  def create_remainder(credit, special_debit_value)
    create_transaction(credit, default_attrs.merge(:value => special_debit_value, :is_debit => false, :source => "loyalty_program_remainder"))
  end

  def create_credits(credits)
    credits.map{|credit| create_transaction(credit, {:source => "loyalty_program_debit"}) }
  end

  def create_transaction(credit, opt_attrs=default_attrs)
    #ORDER ERRADO, SOURCE, REASON
    debit = credit.dup
    debit.is_debit = true
    debit.original_credit_id = credit.id
    debit.tap{|d| opt_attrs.each_pair{|k,v| d.public_send("#{k}=",v)}; d.save! }
  end    

end
