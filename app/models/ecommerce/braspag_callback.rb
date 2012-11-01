class BraspagCallback < ActiveRecord::Base
  belongs_to :order
  belongs_to :payment

  def update_payment_status

  end
end
