# -*- encoding : utf-8 -*-
module Invites
  class Send
    @queue = :send_invites

    def self.perform
      users_with_pending_invites = Invite.select(:user_id).unsent.group('user_id').map(&:user_id)

      express_delivery = []
      batch_delivery = []

      User.where(:id => users_with_pending_invites).each do |member|
        if (member.invites.unsent.count <= 20)
          express_delivery += member.invites.unsent.map(&:id)
        else
          batch_delivery += member.invites.unsent.map(&:id)
        end
      end

      Resque.enqueue(Invites::ExpressDelivery, express_delivery) unless express_delivery.empty?
      Resque.enqueue(Invites::BatchDelivery, batch_delivery) unless batch_delivery.empty?
    end
  end
end
