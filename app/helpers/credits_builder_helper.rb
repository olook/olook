module CreditsBuilderHelper
  private
  attr_accessor :default_attrs

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
    credits = {}
    catch(:sufficient_amount) do
      user_credit.credits.where(is_debit: false).find_each do |credit|
        credits.merge!(credit => credit.value)
        throw(:sufficient_amount, credits.keys) if credits.values.sum  >= amount 
      end
    end
  end

  def attrs
    default_attrs || {}
  end

  def create_special_credit(credit, special_debit_value)
    create_credit(credit, attrs.merge(:value => special_debit_value, :is_debit => false))
  end

  def create_credits(credits)
    credits.map{|credit| create_credit(credit) }
  end

  def create_credit(credit, merged_attrs={})
    debit = credit.dup
    debit.is_debit = true
    debit.tap{|d| merged_attrs.each_pair{|k,v| d.public_send("#{k}=",v)}; d.save! }
  end
end