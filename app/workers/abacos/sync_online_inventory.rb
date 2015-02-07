# -*- encoding : utf-8 -*-
module Abacos
  class SyncOnlineInventory
    @queue = 'low'

    def self.perform(qty = 500)
      notifications = []
      errors = []
      all_numbers = ::Variant.order('inventory DESC').select(:number).map {|v| v.number}

      while all_numbers.size > 0
        numbers = all_numbers.shift(qty)
        begin
          results = Abacos::ProductAPI.download_online_inventory numbers
        rescue => e
          errors.concat numbers
          next
        end
        i_results = results.inject({}) { |h,i| h[i.last] ||= []; h[i.last].push(i.first); h }
        i_results.each do |inventory, v_numbers|
          platform_variants_with_inventory_different = ::Variant.where(number: v_numbers).where('inventory <> ?', inventory).pluck(:number)
          if platform_variants_with_inventory_different.size > 0
            notifications.concat(platform_variants_with_inventory_different)
            ::Variant.where(number: platform_variants_with_inventory_different).update_all(inventory: inventory)
          end
        end
      end


      Rails.logger.info("Abacos::SyncOnlineInventory just (#{Time.zone.now.strftime('%Y-%m-%d %H:%M')}) updated #{notifications.size} variants\n#{notifications.join("\n")}")
      ActionMailer::Base.mail(
        from: 'dev@olook.com.br',
        to: ['tech@olook.com.br', 'nelsonmhjr@gmail.com'],
        subject: "Abacos::SyncOnlineInventory updated #{notifications.size} variants #{Time.zone.now.strftime('%Y-%m-%d %H:%M')}",
        body: "<pre>Abacos::SyncOnlineInventory just (#{Time.zone.now.strftime('%Y-%m-%d %H:%M')}) updated #{notifications.size} variants\n#{notifications.join("\n")}</pre>" +
        "<pre>\nErros:#{errors.join("\n")}</pre>"
      ).deliver
    end
  end
end
