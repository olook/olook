# -*- encoding : utf-8 -*-
module Abacos
  class SyncOnlineInventory
    @queue = 'low'

    def self.perform(qty = 500)
      notifications = []
      all_numbers = ::Variant.order(inventory: :desc).pluck(:number)

      while all_numbers.size > 0
        numbers = all_numbers.shift(qty)
        results = Abacos::ProductAPI.download_online_inventory numbers
        i_results = results.inject({}) { |h,i| h[i.last] ||= []; h[i.last].push(i.first); h }
        i_results.each do |inventory, v_numbers|
          platform_variants_with_inventory_different = ::Variant.where(number: v_numbers).where('inventory <> ?', inventory).pluck(:number)
          if platform_variants_with_inventory_different.size > 0
            notifications.concat(update_numbers)
            ::Variant.where(number: update_numbers).update_all(inventory: inventory)
          end
        end
      end


      Rails.logger.info("Abacos::SyncOnlineInventory just (#{Time.zone.now.strftime('%Y-%m-%d %H:%M')}) updated #{notifications.size} variants\n#{notifications.join("\n")}")
      ActionMailer::Base.mail(
        from: 'dev@olook.com.br',
        to: ['tech@olook.com.br', 'nelsonmhjr@gmail.com'],
        subject: "Abacos::SyncOnlineInventory updated #{notifications.size} variants #{Time.zone.now.strftime('%Y-%m-%d %H:%M')}",
        body: "<pre>Abacos::SyncOnlineInventory just (#{Time.zone.now.strftime('%Y-%m-%d %H:%M')}) updated #{notifications.size} variants\n#{notifications.join("\n")}</pre>"
      ).deliver
    end
  end
end
