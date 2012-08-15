class LoyaltyProgramCreditType < CreditType

  def credit_sum(user_credit, date, is_debit)
  	user_credit.credits.where("activates_at <= ? AND expires_at >= ? AND is_debit = ?", date, date, is_debit).sum(:value)
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
      true
    else
      false
    end
  end

  def add(amount, user_credit, order)
    updated_total = user_credit.total + amount
    user_credit.credits.create!(:activates_at => period_start, :expires_at => period_end, :user => user_credit.user, :value => amount, :total => updated_total, :order => order, :source => "loyalty_program_credit",
    :reason => "Fidelity credits for order #{order.number}")
  end

  private 
    def period_start date = DateTime.now
      date += 1.month
      date.at_beginning_of_month
    end

    def period_end date = DateTime.now
      date += 2.months
      date.at_end_of_month
    end

end
