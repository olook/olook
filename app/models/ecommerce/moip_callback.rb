# -*- encoding : utf-8 -*-
class MoipCallback < ActiveRecord::Base
  belongs_to :order
  belongs_to :payment
end
