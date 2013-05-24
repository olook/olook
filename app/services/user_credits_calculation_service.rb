class UserCreditsCalculationService
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def user_credits_sum(options = {})
    if options[:types]
      total_credits = BigDecimal.new("0")
      options[:types].each do |credit_type|
        total_credits += user.user_credits_for(credit_type).total
      end
      total_credits
    else
      user.current_credit.to_d
    end
  end
end
