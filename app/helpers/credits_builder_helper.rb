module CreditsBuilderHelper
  private

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
    debit.tap{|d| opt_attrs.each_pair{|k,v| d.public_send("#{k}=",v)}; d.save! }
  end
end