  # -*- encoding : utf-8 -*-
class AdminCreditService 
 
  TRANSACTION_LIMIT = CreditService::CREDIT_CONFIG['admin_credit_service']['transaction_limit']

  def initialize(admin)
    @admin = admin
  end

  def has_exceeded_transaction_limit?(value)
    value > TRANSACTION_LIMIT ? true : false
  end

  def add_credit(value, reason, user)
    if user.has_not_exceeded_credit_limit?(value) 

      updated_total = user.current_credit + value
      user.credits.create!(:value => value, :total => updated_total, :source => "Added by #{@admin.name}", :reason => reason)
    else
      error "The limit has passed"
    end
  end

  def remove_credit(value, reason, user)
    if user.current_credit >= value
      updated_total = user.current_credit - value
      user.credits.create!(:value => value, :total => updated_total, :source => "Removed by #{@admin.name}",
        :reason => reason, :is_debit => true)
    else
      false
    end
  end



end