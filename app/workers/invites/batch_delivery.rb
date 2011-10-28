# -*- encoding : utf-8 -*-
module Invites
  class BatchDelivery
    @queue = :send_invites

    def self.perform(invite_ids)
    end
  end
end
