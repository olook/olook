class BraspagAuthorizeResponse < ActiveRecord::Base
  scope :to_process, where(:processed => false).order(:id)

  def update_payment_status(payment)
    
  end
end
