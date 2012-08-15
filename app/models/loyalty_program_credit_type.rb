class LoyaltyProgramCreditType < CreditType

  def credit_sum(user_credit, date, is_debit)
  	user_credits(user_credit, date, is_debit).sum(:value)
  end

  #TODO: create a mechanism that nullifies the available credits until the debit is paid
  def remove(amount, user_credit, order)
    # busca os creditos mais proximos de expirar e que nao foram usados
    #  cria um debito para anular cada um dos creditos. 
    #  Caso todo o debito seja processado e ainda tenha sobrado creditos, anula todo o credito do ultimo
    #  e cria um credito novo com o que sobrou.
    #  Cada um dos creditos utilizados devem ter o debito designado, para ser marcado como usado.
    #  NOTA: TODOS OS DEBITOS (E O CREDITO DE RESTO GERADO) DEVERAO TER AS MESMAS DATAS DE ATIVACAO E EXPIRACAO DOS CREDITOS CORRESPONDENTES. 

    if user_credit.total >= amount
      credits = {}

      user_credits(user_credit,Time.zone.now,false).find_each do |credit|
        if credits.values.sum  < amount
          credits.merge!(credit => credit.value) 
        else
          break
        end
      end

      build_debits(credits.keys, amount)
    else
      false
    end
  end

  def add(amount, user_credit, order)
    updated_total = user_credit.total + amount
    user_credit.credits.create!(:activates_at => period_start, :expires_at => period_end, :user => user_credit.user, :value => amount, :total => updated_total, :order => order, :source => "loyalty_program_credit",
    :reason => "Loyalty program credits for order #{order.number}")
  end

  private

    def build_debits(credits, amount)
      total_of_credits    = credits.map(&:value).sum
      special_debit_value = total_of_credits - amount

      if special_debit_value.zero?
        create_debits(credits)
      else
        [create_debits(credits),
        create_special_debit(credits.last, special_debit_value)].flatten
      end
    end

    def create_special_debit(credit, special_debit_value)
      create_debit(credit.clone, :value => special_debit_value, :is_debit => false)
    end

    def create_debits(credits)
      credits.map{|credit| create_debit(credit) }
    end

    def create_debit(credit, attrs={})
      debit = credit.dup
      debit.is_debit = true
      debit.tap{|d| attrs.each_pair{|k,v| d.public_send("#{k}=",v)}; d.save! }
    end

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

end
